{
    lib,
    config,
    pkgs,
    ...
}: {
    # Deliberately conservative sibling to NOlaptop.nix. That profile has been
    # chasing an unresolved amdgpu MES/gfxoff hang on the 780M iGPU (gfx1103)
    # -- kernel pins, unmerged patches, param experimentation, all still
    # unproven. This profile exists to boot reliably when that one can't.
    #
    # Rules for this file: nothing here should be an active experiment.
    # Only long-established, widely-documented fixes belong -- if it's not
    # confirmed upstream or by a broad community consensus, it goes in
    # NOlaptop.nix instead, not here.

    environment.systemPackages = with pkgs; [
        # keep-sorted start
        framework-tool
        fw-ectool
        # keep-sorted end
    ];

    services.udev.extraRules = ''
        ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"
        ACTION=="add|change", KERNEL=="i2c", SUBSYSTEM=="i2c", DEVPATH=="/sys/devices/platform/AMDI0010:03/i2c-1/i2c-PIXA3854:00", ATTR{power/wakeup}="disabled"
    '';

    services.fprintd.enable = true;

    services.xserver.videoDrivers = ["amdgpu"];

    systemd.services."backlight@backlight:amdgpu_bl2".enable = false;

    # LTS branch, well past the 6.14+ window where community reports show the
    # MES-hang frequency getting noticeably worse (Ubuntu/Framework users saw
    # roughly 1-2 crashes/day on 6.11-era kernels vs every 5-15 min on 6.14
    # OEM). No confirmed-clean kernel exists for this exact chip, but this is
    # the best-evidenced conservative choice. Deliberately *not* pinned to
    # nixpkgs-unstable or any patched kernel -- this profile only moves when
    # a fix is confirmed, not to chase one.
    boot.kernelPackages = pkgs.linuxPackages_6_12;

    boot.kernelParams = [
        # Lets the driver attempt to recover from a GPU hang instead of
        # leaving the display permanently black -- a strict improvement for
        # a box whose whole point is not needing a hard power cycle.
        "amdgpu.gpu_recovery=1"
        # Disables PSR (Panel Self Refresh). Documented, upstream-acknowledged
        # fix for eDP panel hangs on this hardware, not an experiment:
        # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
        # (nixos-hardware's framework-16-7040-amd module sets this too; kept
        # explicit here so this file doesn't silently depend on import order.)
        "amdgpu.dcdebugmask=0x10"
    ];
    boot.kernelModules = ["amdgpu"];

    # The whole point of this profile is to not be boxed in by bcachefs's
    # narrow, fast-moving kernel-version window the way NOlaptop.nix now is
    # (nixpkgs marks the out-of-tree bcachefs module broken outside a narrow
    # >=6.16 range, which is what forced the 6.18/7.x choice over there).
    # Root filesystem here should be ext4 or btrfs -- enforced here so this
    # profile can't accidentally end up needing bcachefs kernel support even
    # if a disk-config gets reused incorrectly.
    boot.supportedFilesystems.bcachefs = lib.mkForce false;

    powerManagement.cpuFreqGovernor = "powersave";

    networking.hostName = "NOlaptop-stable";
}
