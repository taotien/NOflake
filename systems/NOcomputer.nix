{pkgs, ...}: {
  services.pipewire.enable = false;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  environment.systemPackages = with pkgs; [
    # egl-wayland
    # gpt4all-chat
    # nvidia-vaapi-driver
    # foldingathome
    gwe
    mesa
    openrgb
    snapper
  ];

  services.tailscale.useRoutingFeatures = "both";
  boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = "1";

  # services.foldingathome = {
  #   enable = true;
  #   team = 223518;
  #   user = "Tao_Tien";
  #   extraArgs = ["--passkey=76ba03d55acf116776ba03d55acf1167"];
  # };

  environment.sessionVariables = {
    # wayland chromium workaround
    NIXOS_OZONE_WL = "1";

    #   # firefox nvidia-vaapi-driver
    #   # MOZ_DISABLE_RDD_SANDBOX = "1";
    #   # LIBVA_DRIVER_NAME = "nvidia";
  };

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
  fileSystems."/home/tao/Games" = {
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

  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = ["tao"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = "5";
      TIMELINE_LIMIT_DAILY = "7";
    };
  };
  services.snapper.snapshotInterval = "*:0/5";

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.kernelModules = ["i2c-dev" "kvm-amd"];
  boot.kernelParams = ["nvidia-drm.modeset=1"];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
  # boot.blacklistedKernelModules = with config.boot.kernelPackages; [ k10temp ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # options: production, beta, vulkan_beta, latest
    package = pkgs.linuxPackages_zen.nvidiaPackages.latest;
    open = true;
  };
  # enable core and mem freq sliders for nvidia
  services.xserver.deviceSection = ''
    Option "Coolbits" "8"
  '';
  systemd.services.nvpl = {
    description = "Increase GPU power limit to 400w";
    script = "/run/current-system/sw/bin/nvidia-smi -pl=400";
    wantedBy = ["multi-user.target"];
  };

  services.udev.packages = [pkgs.openrgb];
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a3c5", MODE="0666"
  '';

  # windows can suck my ass
  time.hardwareClockInLocalTime = true;

  # services.xserver.displayManager = {
  #   autoLogin.enable = true;
  #   autoLogin.user = "tao";
  # };

  networking.hostName = "NOcomputer";
}
