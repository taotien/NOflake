{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
    autoResize = true;
  };
  programs.partition-manager.enable = false;

  services.printing.enable = false;
  services.btrfs.autoScrub.enable = false;

  boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" ];
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  # console.enable = false;
  # powerManagement.cpuFreqGovernor = "ondemand";

  hardware = {
    raspberry-pi."4" = {
      # apply-overlays-dtmerge.enable = true;
      # audio.enable = true;
      fkms-3d.enable = true;
    };
    # deviceTree = {
    # enable = true;
    # filter = "*rpi-4-*.dtb";
    # };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "23.11";
  networking.hostName = "NObangers";
}
