{ config, pkgs, ... }: {
  services.xserver.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "tao";
  };

  environment.systemPackages = with pkgs;
    [
      # egl-wayland
      # mesa
      nvidia-vaapi-driver
      gwe
      liquidctl
      openrgb
      snapper
    ];

  environment.sessionVariables = {
    # wayland chromium workaround
    NIXOS_OZONE_WL = "1";
    # firefox nvidia-vaapi-driver
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
    fsType = "btrfs";
    options = [ "subvol=home_snaps/0/snapshot" "noatime" "compress-force=zstd:3" ];
  };
  fileSystems."/home/.snapshots" = {
    device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
    fsType = "btrfs";
    options = [ "subvol=home_snaps/" "noatime" "compress-force=zstd:3" ];
  };
  fileSystems."/home/tao/Games" = {
    device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
    fsType = "btrfs";
    options = [ "subvol=games" "nosuid" "nodev" "noatime" "compress-force=zstd:3" "users" "rw" "exec" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2B28-151D";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
    fsType = "btrfs";
    options = [ "subvol=nixos" "noatime" "compress-force=zstd:3" ];
  };
  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
    fsType = "btrfs";
    options = [ "subvol=nixos/var" "noatime" "compress-force=zstd:3" ];
  };
  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
    fsType = "btrfs";
    options = [ "subvol=nixos/tmp" ];
  };
  swapDevices = [{ device = "/dev/disk/by-uuid/ca0ed3d7-8758-4ac7-b016-8b4cd9608ded"; }];

  services.snapper.configs =
    {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "tao" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "5";
        TIMELINE_LIMIT_DAILY = "7";
      };
    };
  services.snapper.snapshotInterval = "*:0/5";

  # systemd.user.services.fans = {
  #   description = "NZXT fans to 69% using liquidctl";
  #   script = ''
  #     ${pkgs.liquidctl}/bin/liquidctl -m nzxt set sync speed 69
  #   '';
  #   wantedBy = [ "default.target" ];
  # };

  # boot.kernelPackages = pkgs.linuxPackages_6_5;
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "i2c-dev" "kvm-amd" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
  # boot.blacklistedKernelModules = with config.boot.kernelPackages; [ k10temp ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = "1";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # package = config.boot.kernelPackages.nvidiaPackages.latest;
    # package = pkgs.unstable.linuxPackages_latest.nvidiaPackages.vulkan_beta;
    # package = pkgs.unstable.linuxPackages_latest.nvidiaPackages.latest;
    package = pkgs.unstable.linuxPackages_latest.nvidiaPackages.production;
  };
  # enable core and mem freq sliders for nvidia
  services.xserver.deviceSection = ''
    Option "Coolbits" "8"
  '';
  systemd.services.nvpl = {
    description = "Increase GPU power limit to 400w";
    script = "/run/current-system/sw/bin/nvidia-smi -pl=400";
    wantedBy = [ "multi-user.target" ];
  };

  services.udev.packages = [ pkgs.openrgb ];
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a3c5", MODE="0666"
  '';

  time.hardwareClockInLocalTime = true;
  networking.hostName = "NOcomputer";
}
