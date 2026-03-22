# NixOS Fresh Installation Guide

How to install NixOS on a new machine and apply this configuration from scratch.

---

## 1. Boot the installer

Download the minimal or GNOME ISO from <https://nixos.org/download> and boot from it.

---

## 2. Partition and format

Use `gnome-disks`, `gparted`, or `fdisk`. A typical UEFI layout:

| Partition | Size | Type | Mount |
| --- | --- | --- | --- |
| EFI | 512 MB | FAT32 | `/boot/efi` |
| Root | remainder | ext4 / btrfs | `/` |

```bash
# Example with fdisk + mkfs (adjust /dev/sdX to your disk)
fdisk /dev/sdX          # create GPT, EFI (type 1), Linux (type 20)
mkfs.fat -F 32 /dev/sdX1
mkfs.ext4 /dev/sdX2

mount /dev/sdX2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sdX1 /mnt/boot/efi
```

---

## 3. Generate hardware config

```bash
nixos-generate-config --root /mnt
```

This writes `/mnt/etc/nixos/hardware-configuration.nix`. Copy it to the repo later.

---

## 4. Clone this repo

```bash
# Enable flakes for the live session
export NIX_CONFIG="experimental-features = nix-command flakes"

# Install git temporarily
nix-shell -p git

cd /mnt/home   # or wherever you want
git clone https://github.com/shourovrm/nixos-config.git
```

---

## 5. Get the hardware config into the repo

```bash
cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/home/rms/nixos-config/hosts/rms-laptop/hardware-configuration.nix
```

> If this is a **new host** (not rms-laptop), create a new folder:
> ```
> hosts/rms-newhost/
> ├── configuration.nix       ← copy & adapt from rms-laptop
> └── hardware-configuration.nix
> ```
> Then add `nixosConfigurations.rms-newhost` to `flake.nix`.

---

## 6. Review `configuration.nix`

Edit `hosts/rms-laptop/configuration.nix` and confirm:
- `networking.hostName` is correct
- GRUB paths match your setup (`efiSysMountPoint`, `device`)
- Your username is set under `users.users`

---

## 7. Install

```bash
nixos-install --flake /mnt/home/rms/nixos-config#rms-laptop --root /mnt
```

Set the root password when prompted. Then set the user password:

```bash
nixos-enter --root /mnt
passwd rms
exit
```

---

## 8. Reboot and finish

```bash
reboot
```

Log in as `rms`. Then initialise git tracking of the config:

```bash
cd ~/nixos-config
git init
git add .
git commit -m "feat: initial install on $(hostname)"
git remote add origin git@github.com:shourovrm/nixos-config.git
git push -u origin main
```

---

## 9. Python general environment

After first login, create the default Python venv (uv is already installed):

```bash
uv venv ~/.venv/general
```

It will auto-activate on every new shell (configured in bash).
