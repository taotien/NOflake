{ lib, pkgs, modulesPath, ... }: {
  environment.systemPackages = with pkgs; [
    exfatprogs
    appimage-run
    bat
    bottom
    cifs-utils
    du-dust
    firefox
    git
    helix
    mpv
    nfs-utils
    nil
    nixpkgs-fmt
    onlyoffice-bin
    ouch
    ripgrep-all
    rustup
    skim
    tree
    wezterm
    wget
    zstd
  ];

  services.tailscale.enable = lib.mkDefault true;
  services.openssh.enable = lib.mkDefault true;
  services.flatpak.enable = lib.mkDefault true;
  services.printing.enable = lib.mkDefault true;

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  environment.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = lib.mkDefault true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  systemd.services.display-manager.restartIfChanged = false;
  services.xserver.displayManager.sddm.enable = lib.mkDefault true;
  services.xserver.desktopManager.plasma5.enable = lib.mkDefault true;
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    konsole
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  nixpkgs.config = { allowUnfree = true; };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  time.timeZone = "US/Pacific";
  i18n.defaultLocale = "en_US.UTF-8";

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.05";
}
