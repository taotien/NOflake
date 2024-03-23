{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # macchina
    bat
    bottom
    cifs-utils
    du-dust
    exfatprogs
    git
    inputs.helix.packages.${pkgs.system}.default
    localsend
    mesa
    neofetch
    ouch
    pueue
    ripgrep
    rustdesk
    screen
    skim
    tree
    wezterm
    wget
    zstd
  ];
  programs.firefox.enable = true;
  programs.partition-manager.enable = lib.mkDefault true;

  programs.firefox.policies = {
    DisablePocket = true;
    PasswordManagerEnabled = false;
    NoDefaultBookmarks = false;
  };

  services.xserver.enable = lib.mkDefault true;
  services.xserver.xkb.layout = "us";
  systemd.services.display-manager.restartIfChanged = false;
  services.xserver.displayManager.sddm.enable = lib.mkDefault true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;
  environment.plasma6.excludePackages = with pkgs; [
    elisa
    konsole
    gwenview
    kate
    xterm
  ];

  services.openssh.enable = true;
  # services.flatpak.enable = lib.mkDefault true;
  services.printing.enable = lib.mkDefault true;

  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.tailscale.package = pkgs.tailscale;
  # services.resolved.enable = true;
  # networking.interfaces.tailscale0.useDHCP = false;

  services.smartd.enable = true;
  services.btrfs.autoScrub.enable = lib.mkDefault true;

  hardware.pulseaudio.enable = lib.mkDefault false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = lib.mkDefault true;
  };

  security.sudo-rs.enable = true;

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
      fcitx5-rime
    ];
  };

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

  # time.timeZone = "US/Pacific";
  services.automatic-timezoned.enable = lib.mkDefault true;
  i18n.defaultLocale = "en_US.utf8";
  i18n.supportedLocales = ["all"];
  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.loader.timeout = lib.mkForce 1;
  boot.supportedFilesystems = ["ntfs" "btrfs"];
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = lib.mkDefault true;

  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = ["root" "@wheel"];
  };
  nixpkgs.config = {allowUnfree = true;};

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = lib.mkDefault "23.05";
}
