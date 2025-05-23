{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        # prescurve
        # libsForQt5.skanpage
        intel-gpu-tools
        powertop
        fw-ectool

        libimobiledevice
        ifuse
    ];

    services.tailscale.useRoutingFeatures = "client";

    powerManagement.powertop.enable = true;
    services.fwupd.enable = true;
    services.fprintd.enable = true;
    hardware.sensor.iio.enable = true;
    services.usbmuxd.enable = true;
    services.usbmuxd.package = pkgs.usbmuxd2;

    services.displayManager.sddm.wayland.enable = true;

    # systemd.user.services.backlight = {
    #   # description = "";
    #   ExecStart = "${pkgs.prescurve}/bin/prescurve_backlight";
    #   Restart = "on-failure";
    #   wantedBy = [ "default.target" ];
    # };
    # hardware.sane = {
    #   enable = true;
    #   extraBackends = [ pkgs.epkowa ];
    # };

    services.udev.extraRules = ''
        # Ethernet expansion card
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"

        ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
        ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/e4244a97-9b48-49f0-8093-782163045020";
        fsType = "btrfs";
        options = ["subvol=home-snaps/0/snapshot" "noatime" "compress-force=zstd:3" "discard=async"];
    };
    fileSystems."/home/tao/Games" = {
        device = "/dev/disk/by-uuid/e4244a97-9b48-49f0-8093-782163045020";
        fsType = "btrfs";
        options = ["subvol=games" "nosuid" "nodev" "noatime" "compress-force=zstd:3" "users" "rw" "exec" "discard=async"];
    };
    fileSystems."/" = {
        device = "/dev/disk/by-uuid/e4244a97-9b48-49f0-8093-782163045020";
        fsType = "btrfs";
        options = ["subvol=nixos" "noatime" "compress-force=zstd:3" "discard=async"];
    };
    swapDevices = [{device = "/dev/disk/by-uuid/ca55d0ea-c0db-44c5-af3a-e38eec803929";}];

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.initrd.availableKernelModules = [
        "nvme"
        "sd_mod"
        "thunderbolt"
        "usb_storage"
        "xhci_pci"
    ];
    boot.kernelParams = [
        "acpi_osi=\"!Windows 2020\""
        "nvme.noacpi=1"
        "i915.enable_psr=1"
    ];
    boot.blacklistedKernelModules = ["cros-usbpd-charger"];
    boot.extraModprobeConfig = ''options snd-hda-intel model=dell-headset-multi'';
    boot.kernelModules = ["kvm-intel"];
    powerManagement.cpuFreqGovernor = "powersave";
    systemd.sleep.extraConfig = "HibernateDelaySec=180m";
    # boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
    # boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = "1";

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
        {
            hostName = "nolaptop";
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

    networking.hostName = "NOmom";
}
