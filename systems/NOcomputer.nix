{
    config,
    pkgs,
    lib,
    ...
}: {
    environment.systemPackages = with pkgs; [
        # nvtopPackages.nvidia
        # egl-wayland
        # gpt4all-chat
        # nvidia-vaapi-driver
        # foldingathome
        # gwe
        # openrgb
        openrgb-plugin-effects
        openrgb-plugin-hardwaresync
    ];

    environment.sessionVariables = {
        # wayland chromium workaround
        NIXOS_OZONE_WL = "1";

        # firefox nvidia-vaapi-driver
        # MOZ_DISABLE_RDD_SANDBOX = "1";
        # LIBVA_DRIVER_NAME = "nvidia";
    };

    hardware.nvidia = {
        powerManagement.enable = true;
        open = true;
    };
    services.tailscale.useRoutingFeatures = "both";
    boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = "1";

    systemd.services.nvpl = {
        description = "Increase GPU power limit to 400w";
        script = "/run/current-system/sw/bin/nvidia-smi -pl=400";
        wantedBy = ["multi-user.target"];
    };
    services.lact.enable = true;

    services.syncplay = {
        enable = true;
        motd = "we only watch kino here";
    };

    services.udev.extraRules = ''
        # pcpanel
        KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a3c5", MODE="0666"
    '';
    services.hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    boot.kernelModules = ["i2c-dev" "kvm-amd" "nct6775"];
    boot.kernelParams = ["nvidia-drm.modeset=1"];
    # boot.initrd.kernelModules = ["nvidia"];
    # boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
        fsType = "btrfs";
        options = ["subvol=home_snaps/0/snapshot" "noatime" "compress-force=zstd:3" "discard=async"];
    };
    fileSystems."/home/.snapshots" = {
        device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
        fsType = "btrfs";
        options = ["subvol=home_snaps/" "noatime" "compress-force=zstd:3" "discard=async"];
    };
    fileSystems."/home/tao/games" = {
        device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
        fsType = "btrfs";
        options = ["subvol=games" "nosuid" "nodev" "noatime" "compress-force=zstd:3" "users" "rw" "exec" "discard=async"];
    };
    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/2B28-151D";
        fsType = "vfat";
    };
    fileSystems."/" = {
        device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
        fsType = "btrfs";
        options = ["subvol=nixos" "noatime" "compress-force=zstd:3" "discard=async"];
    };
    fileSystems."/var" = {
        device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
        fsType = "btrfs";
        options = ["subvol=nixos/var" "noatime" "compress-force=zstd:3" "discard=async"];
    };
    fileSystems."/tmp" = {
        device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
        fsType = "btrfs";
        options = ["subvol=nixos/tmp" "discard=async"];
    };
    swapDevices = [{device = "/dev/disk/by-uuid/ca0ed3d7-8758-4ac7-b016-8b4cd9608ded";}];

    # windows can suck my ass
    time.hardwareClockInLocalTime = true;

    networking.hostName = "NOcomputer";
}
