# NixOS Fresh Installation Guide

Complete walkthrough — from booting the minimal ISO to a fully running system.
Covers both a **fresh disk** (sole OS) and **dual-boot alongside Windows**.

---

## 0. Prerequisites

| Item | Notes |
| --- | --- |
| NixOS minimal ISO | Download from <https://nixos.org/download> — use the **minimal** image, not the GNOME installer |
| USB drive ≥ 2 GB | For flashing the ISO |
| Internet | Wired is simplest during install; Wi-Fi steps below |
| Target disk identifier | Find with `lsblk` once booted (e.g. `/dev/nvme0n1` or `/dev/sda`) |

Flash the ISO:

```bash
# on any Linux machine (replace /dev/sdX with your USB drive!)
dd if=nixos-minimal-*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

Boot the target machine from the USB.  Select the first entry in the boot menu.
You will land at a root shell.

---

## 1. Network

### Wired (automatic)

Usually works out of the box.  Verify:

```bash
ip a       # should show an IP on eth0 / enpXsY
ping -c2 1.1.1.1
```

### Wi-Fi

```bash
# Start the interactive wireless tool
iwctl

[iwd] device list                  # e.g. wlan0
[iwd] station wlan0 scan
[iwd] station wlan0 get-networks
[iwd] station wlan0 connect "SSID"
[iwd] quit

ping -c2 1.1.1.1                   # confirm connectivity
```

---

## 2. Identify your disk

```bash
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE
```

Typical names:

| Hardware | Usual name |
| --- | --- |
| NVMe SSD | `/dev/nvme0n1` |
| SATA SSD / HDD | `/dev/sda` |
| Second SATA drive | `/dev/sdb` |

**Pick one scenario below and follow only that section.**

---

## 3A. Fresh disk — NixOS only

> Use this when the target disk is empty or you are wiping everything.

```bash
DISK=/dev/nvme0n1   # ← change to your disk
```

### Partition

```bash
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart primary ext4 512MiB 100%
```

This creates:

| Partition | Device | Purpose |
| --- | --- | --- |
| 1 | `${DISK}p1` (NVMe) or `${DISK}1` (SATA) | EFI System Partition |
| 2 | `${DISK}p2` / `${DISK}2` | Root filesystem |

### Format

```bash
# Adjust p1/p2 → 1/2 if your disk is /dev/sda (SATA)
mkfs.fat -F 32 -n EFI  ${DISK}p1
mkfs.ext4 -L nixos      ${DISK}p2
```

### Mount

```bash
mount /dev/disk/by-label/nixos    /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/EFI      /mnt/boot/efi
```

---

## 3B. Dual-boot alongside Windows

> Use this when Windows is already installed and you want to keep it.
> Windows must already be using GPT + UEFI — if it isn't (old MBR setup), convert
> it first with MBR2GPT inside Windows before continuing.

### Check existing partitions

```bash
fdisk -l $DISK    # or: parted $DISK print
```

You should see a Windows layout similar to:

| # | Size | Type | Notes |
| --- | --- | --- | --- |
| 1 | 100 MB | EFI System | Windows ESP — **do NOT format** |
| 2 | 16 MB | Microsoft reserved | |
| 3 | ~C: drive | Microsoft basic data | Windows itself |
| 4 | 500 MB | Windows recovery | |

### Shrink Windows from inside Windows first

1. Boot Windows.
2. Open **Disk Management** (`diskmgmt.msc`).
3. Right-click the Windows partition (C:) → **Shrink Volume**.
4. Enter the amount to shrink in MB (e.g. `51200` for 50 GB, `102400` for 100 GB).
5. Click **Shrink**.  A new "Unallocated" block appears — leave it unallocated, shut down.

> **Do not** resize partitions in the NixOS live session with Windows hibernation active.
> Always shut Windows down cleanly (`Shut down`, not restart).

### Create the Linux partition in the unallocated space

```bash
DISK=/dev/nvme0n1   # ← your disk
```

```bash
# Find the unallocated start sector
parted $DISK unit MiB print free   # note "Free Space" start/end

# Create one big Linux partition in that free space
# (replace START and END with the values from the output above)
parted $DISK -- mkpart primary ext4 STARTMiB ENDMiB
```

If you need a swap partition (optional — not needed with enough RAM):

```bash
parted $DISK -- mkpart primary linux-swap STARTMiB +8GiB
parted $DISK -- mkpart primary ext4 $(expr START + 8192)MiB ENDMiB
```

### Format and mount

```bash
# Replace Xp3 with the actual partition number of your new Linux partition
ROOTPART=/dev/nvme0n1p5   # example — verify with lsblk

mkfs.ext4 -L nixos $ROOTPART

mount /dev/disk/by-label/nixos /mnt

# Reuse the existing Windows EFI partition — do NOT mkfs it
mkdir -p /mnt/boot/efi
# Identify the EFI partition number (usually p1) then:
mount /dev/nvme0n1p1 /mnt/boot/efi
```

### Enable os-prober in the config

Before installing, make sure `hosts/rms-laptop/configuration.nix` (or your new
host's config) has:

```nix
boot.loader.grub.useOSProber = true;
```

This is already set in the existing config.  GRUB will detect Windows and add it
to the boot menu automatically.

---

## 4. Generate hardware config

```bash
nixos-generate-config --root /mnt
```

This produces `/mnt/etc/nixos/hardware-configuration.nix`.

---

## 5. Enable flakes and get git

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nix-shell -p git
```

---

## 6. Clone this repo

```bash
mkdir -p /mnt/home/rms
git clone https://github.com/shourovrm/nixos-config.git /mnt/home/rms/nixos-config
```

---

## 7. Copy the hardware config into the repo

```bash
cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/home/rms/nixos-config/hosts/rms-laptop/hardware-configuration.nix
```

---

## 8. Choose: same host or new host?

### Same host (`rms-laptop`)

Edit `hosts/rms-laptop/configuration.nix` and verify:

- `networking.hostName = "rms-laptop"` — change if desired
- `boot.loader.efi.efiSysMountPoint = "/boot/efi"` — matches the mount above
- `boot.loader.grub.device = "nodev"` — correct for UEFI
- `users.users.rms.initialPassword` — set a temporary password if desired

That's it.  Use `--flake ...#rms-laptop` in the install step.

### New host

```bash
# Example new hostname: my-desktop
HOST=my-desktop
mkdir /mnt/home/rms/nixos-config/hosts/$HOST
cp /mnt/home/rms/nixos-config/hosts/rms-laptop/configuration.nix \
   /mnt/home/rms/nixos-config/hosts/$HOST/configuration.nix
cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/home/rms/nixos-config/hosts/$HOST/hardware-configuration.nix
```

Edit `hosts/$HOST/configuration.nix`:
- Change `networking.hostName` to `$HOST`
- Adjust any hardware-specific paths

Then add the new host to `flake.nix`:

```nix
nixosConfigurations = {
  rms-laptop = mkSystem "rms-laptop";

  # Add this:
  my-desktop = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/my-desktop/configuration.nix
      home-manager.nixosModules.home-manager
      { home-manager.users.rms = import ./home/rms/home.nix; }
    ];
  };
};
```

Use `--flake ...#my-desktop` in the install step.

---

## 9. Install NixOS

```bash
nixos-install --flake /mnt/home/rms/nixos-config#rms-laptop --root /mnt
```

This will download and build all packages.  It may take 10–30 minutes depending
on internet speed.

When prompted, set a **root password** (you can change it later).

---

## 10. Set your user password before rebooting

```bash
nixos-enter --root /mnt
passwd rms          # set a login password for your user
exit
```

---

## 11. Reboot

```bash
umount -R /mnt
reboot
```

Remove the USB when prompted (or immediately after POST).

For dual-boot: GRUB will appear with NixOS and Windows entries.

---

## 12. First login — fix ownership and activate Home Manager

Log in as `rms` at GDM.  Open a terminal.

```bash
# The repo was cloned as root during install; fix ownership
sudo chown -R rms:users ~/nixos-config

# Enter the config directory (bash alias: cdnix)
cd ~/nixos-config

# Apply home-manager (first time only — subsequent rebuilds use nixswitch)
nix run home-manager/master -- switch --flake .#rms
```

---

## 13. Full system rebuild (applies any pending changes)

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop
```

Alias `nixswitch` is configured in bash after Home Manager runs.

---

## 14. Post-install checklist

### Python general environment

```bash
uv venv ~/.venv/general
```

Auto-activates in every new shell (configured in `bash.nix`).

### SSH key

```bash
ssh-keygen -t ed25519 -C "rms@$(hostname)"
cat ~/.ssh/id_ed25519.pub   # add to GitHub / servers
```

### Git identity (first time on new machine)

The `git.nix` module sets a global email/name.  Edit
`home/rms/modules/git.nix` if defaults need changing, then rebuild.

### Wallpaper

After Home Manager activates, the wallpaper is copied to
`~/.local/share/wallpapers/wallhaven_eo2p3w.jpg` automatically.
Niri and MangoWC sessions pick it up via `swaybg` on startup.
GNOME picks it up via `dconf.settings` in `niri.nix`.

### Session selection at GDM

Click the **gear icon** on the login screen to choose a session:

| Session | Compositor |
| --- | --- |
| `GNOME` | GNOME desktop (fallback) |
| `niri` | Niri scrollable-tiling (recommended) |
| `mango` | MangoWC dynamic tiling |

### rclone (cloud storage)

```bash
rclone config   # follow prompts to add a Google Drive / S3 remote
```

---

## 15. Rebuilding after config changes

```bash
cd ~/nixos-config

# NixOS system (requires sudo)
sudo nixos-rebuild switch --flake .#rms-laptop

# Home Manager only (no sudo)
home-manager switch --flake .#rms

# Check for evaluation errors without building
nix flake check --no-build

# Update all flake inputs
nix flake update
```

---

## Troubleshooting

### Boot hangs or drops to emergency shell

Check journal: `journalctl -xb` or `journalctl -b -p err`.

Common causes:
- Wrong EFI mount path in `boot.loader.efi.efiSysMountPoint`
- UUID mismatch in `hardware-configuration.nix` (regenerate with `nixos-generate-config`)

### GDM shows only GNOME, mango session missing

The system needs to be rebuilt after importing `modules/nixos/mangowc.nix`:

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop
```

Verify the session file exists after rebuild:

```bash
ls /run/current-system/sw/share/wayland-sessions/
# should show: mango.desktop  niri.desktop
```

### Wi-Fi not working after install

Enable NetworkManager applet or use `nmcli`:

```bash
nmcli device wifi list
nmcli device wifi connect "SSID" password "PASSWORD"
```

### `nix flake check` deprecation warnings

These are pre-existing upstream renames and do not affect functionality:
- `programs.vscode.extensions` → `programs.vscode.profiles.default.extensions`
- `programs.git.userName` → `programs.git.settings.user.name`
- `services.swayidle.events` list → attrset syntax

Fix them when convenient by updating the relevant module.
