{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # xorg.xkill
    bat
    bottom
    cifs-utils
    du-dust
    exfatprogs
    ffmpeg
    firefox
    git
    inputs.helix.packages.${pkgs.system}.default
    # libthai
    localsend
    macchina
    mesa
    mpv
    ouch
    ripgrep
    rustdesk
    screen
    skim
    tree
    wezterm
    # wget
    yt-dlp
    zellij
    zstd
  ];
  programs.partition-manager.enable = lib.mkDefault true;

  services.tailscale.enable = true;
  services.tailscale.package = pkgs.tailscale;
  services.resolved.enable = true;

  services.openssh.enable = true;
  services.flatpak.enable = lib.mkDefault true;
  services.printing.enable = lib.mkDefault true;

  services.smartd.enable = true;
  services.btrfs.autoScrub.enable = lib.mkDefault true;

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "bat";
    SKIM_DEFAULT_COMMAND = "rg --files";
  };

  environment.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "bat";
    SKIM_DEFAULT_COMMAND = "rg --files";
  };

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = lib.mkDefault true;

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.loader.timeout = 1;
  boot.supportedFilesystems = ["ntfs"];

  networking.networkmanager.enable = true;

  # TODO check why this???
  networking.firewall.enable = true;

  services.xserver.enable = lib.mkDefault true;
  services.xserver.xkb.layout = "us";
  systemd.services.display-manager.restartIfChanged = false;
  services.xserver.displayManager.sddm.enable = lib.mkDefault true;
  services.xserver.desktopManager.plasma6.enable = lib.mkDefault true;
  environment.plasma6.excludePackages = with pkgs.libsForQt6; [
    elisa
    konsole
    gwenview
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = lib.mkDefault true;
  };
  hardware.pulseaudio.enable = false;

  security.sudo-rs.enable = true;
  # security.sudo-rs.extraRules = [{
  #   commands = [
  #     { command = "${pkgs.systemd}/bin/bootctl set-oneshot auto-windows"; options = [ "NOPASSWD" ]; }
  #   ];
  #   groups = [ "wheel" ];
  # }];

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = ["root" "@wheel"];
  };
  nixpkgs.config = {allowUnfree = true;};

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  time.timeZone = "US/Pacific";
  i18n.defaultLocale = "en_US.utf8";
  i18n.supportedLocales = ["all"];
  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
      fcitx5-rime
    ];
  };

  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = lib.mkDefault "23.05";
}
