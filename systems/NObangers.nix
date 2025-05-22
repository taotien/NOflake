{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [];
  programs.partition-manager.enable = false;

  services.printing.enable = false;
  i18n.inputMethod = {};

  services.xserver.enable = false;
  services.desktopManager.plasma6.enable = false;

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "23.11";
}
