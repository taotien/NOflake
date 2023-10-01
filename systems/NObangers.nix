{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };
  programs.partition-manager.enable = false;

  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.flatpak.enable = false;
  services.printing.enable = false;
  services.btrfs.autoScrub.enable = false;

  boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" ];
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  console.enable = false;
  powerManagement.cpuFreqGovernor = "ondemand";

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      audio.enable = true;
      fkms-3d.enable = true;
    };
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "23.11";
  networking.hostName = "NObangers";
}
