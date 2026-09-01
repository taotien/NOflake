{
    lib,
    config,
    pkgs,
    ...
}: {
    # nixpkgs.overlays = [
    #   (final: prev: {
    #     libinput = prev.libinput.overrideAttrs (old: {
    #       patches =
    #         (old.patches or [])
    #         ++ [
    #           ../extras/libinput-delay.patch
    #         ];
    #     });
    #   })
    # ];

    environment.systemPackages = with pkgs; [
        # keep-sorted start
        framework-tool
        fw-ectool
        # lact
        nvtopPackages.amd
        # keep-sorted end
    ];

    services.lact.enable = true;

    services.tailscale.useRoutingFeatures = "client";
    systemd.services."backlight@backlight:amdgpu_bl2".enable = false;

    services.udev.extraRules = ''
        # ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
        # ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"

        ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"
        ACTION=="add|change", KERNEL=="i2c", SUBSYSTEM=="i2c", DEVPATH=="/sys/devices/platform/AMDI0010:03/i2c-1/i2c-PIXA3854:00", ATTR{power/wakeup}="disabled"

        # ACTION=="add", SUBSYSTEM=="acpi", DRIVERS=="button", ATTRS{hid}=="PNP0C0D", ATTR{power/wakeup}="disabled"
        # ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
        # ACTION=="add", SUBSYSTEM=="i2c", DRIVERS=="i2c_hid_acpi", ATTRS{name}=="PIXA3854:00", ATTR{power/wakeup}="disabled"
    '';

    services.fprintd.enable = true;

    services.xserver.videoDrivers = [
        "amdgpu"
    ];

    # linuxPackages_latest (7.x) has an unresolved amdgpu regression that hangs
    # the display when the dGPU wakes from runtime suspend (REG_WAIT timeout in
    # dcn31_program_compbuf_size). Pinned to last known-good kernel until fixed
    # upstream: https://github.com/CachyOS/linux-cachyos/issues/810
    boot.kernelPackages = pkgs.linuxPackages_6_18;
    boot.kernelParams = [
        "amdgpu.gpu_recovery=1"
        "amdgpu.abmlevel=1"
        "amdgpu.dcdebugmask=0x400"
    ];
    boot.kernelModules = ["amdgpu"];
    powerManagement.cpuFreqGovernor = "powersave";
    # systemd.sleep.extraConfig = "HibernateDelaySec=360m";

    nix.settings = {
        connect-timeout = 5;
    };
    nix.buildMachines = [
        {
            hostName = "nocomputer";
            systems = ["x86_64-linux" "i686-linux"];
            supportedFeatures = [
                "benchmark"
                "big-parallel"
                "gccarch-znver4"
                "kvm"
                "nixos-test"
            ];
        }
    ];
    nix.extraOptions = ''
        builders-use-substitutes = true
    '';
    nix.distributedBuilds = true;

    networking.hostName = "NOlaptop";
}
