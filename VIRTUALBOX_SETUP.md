# VirtualBox NixOS Setup for Mango WM

## VirtualBox Configuration (Windows Host)

Before booting your NixOS VM, ensure these settings are configured:

### Display Settings
1. **Power off** the NixOS VM
2. Right-click VM → **Settings**
3. Go to **Display** tab:
   - ✅ **Enable "3D Acceleration"** (CRITICAL)
   - Set **Video Memory to 128 MB** (maximum)
   - **Graphics Controller: VMSVGA** (best for Linux)
4. Click **OK**

### Hardware Tab (Optional but Recommended)
- Allocate at least **2 CPU cores**
- Allocate **4 GB RAM** minimum

## NixOS Configuration

Your NixOS config has been updated with:

### Files Modified:
- `modules/system/mango.nix` - Added VirtualBox Guest Additions + graphics packages
- `modules/system/graphics.nix` - Enhanced with DRI, Vulkan, 32-bit support
- `hosts/laptop/configuration.nix` - Enabled graphics.nix module

### Key Changes:
```nix
# VirtualBox Guest Additions
virtualisation.virtualbox.guest.enable = true;

# Enhanced graphics support
hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [ mesa libva vulkan-loader ... ];
};
```

## Testing & Troubleshooting

### After `nixos-rebuild switch`:

1. **Verify 3D acceleration is working:**
   ```bash
   glxinfo | grep "OpenGL version"
   glxinfo | grep "renderer"
   ```
   Should show: Mesa + VMSVGA (not llvmpipe)

2. **Test software fallback (if 3D fails):**
   ```bash
   WLR_RENDERER=pixman mango
   ```

3. **Check VirtualBox integration:**
   ```bash
   systemctl status virtualboxguest*
   ```

## Push to GitHub

```bash
cd d:\git-repos\nixos-config
git add .
git commit -m "Add VirtualBox 3D acceleration and enhanced graphics support"
git push origin main
```

## Load on NixOS Guest

```bash
sudo nixos-rebuild switch --flake github:shourovrm/nixos-config#laptop
```

## Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| Still getting "No 3D enabled" | Verify 3D Acceleration checkbox in VirtualBox Settings |
| DRI2 screen creation fails | Try `WLR_RENDERER=pixman mango` |
| Black screen after boot | Increase VM Video Memory to 128 MB |
| VMware errors (old hypervisor name) | These are harmless in VirtualBox, just warnings |

---

**Last Updated:** 2026-01-03
