{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    [
      # mesa
      openrgb
      gwe
      liquidctl
      # egl-wayland
      # nvidia-vaapi-driver
    ];

  environment.sessionVariables = {
    # wayland chromium workaround
    NIXOS_OZONE_WL = "1";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/eb9fcce2-e9f3-438a-b5ce-8f72f32f0e09";
    fsType = "btrfs";
    options = [ "subvol=home_snaps/0/snapshot" "noatime" "compress-force=zstd:3" ];
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

  systemd.user.services.fans = {
    description = "NZXT fans to 100% using liquidctl";
    script = ''
      ${pkgs.liquidctl}/bin/liquidctl -m nzxt set sync speed 100
    '';
    wantedBy = [ "default.target" ];
  };

  services.udev.packages = [ pkgs.openrgb ];
  services.udev.extraRules = ''
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "i2c-dev" "kvm-amd" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = pkgs.unstable.linuxPackages_latest.nvidiaPackages.production;
  };

  networking.hostName = "NOcomputer";
}
