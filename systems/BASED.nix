{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
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

  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.flatpak.enable = true;
  services.printing.enable = true;

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  imports = [ ./hardware-configuration.nix ];
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.layout = "us";
  systemd.services.display-manager.restartIfChanged = false;
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

  time.timeZone = "US/Pacific";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "23.05";
}
