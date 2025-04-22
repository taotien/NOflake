{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # inputs.helix.packages.${pkgs.system}.default
    # screen
    bat
    bottom
    cifs-utils
    du-dust
    dumbpipe
    exfatprogs
    fastfetch
    ffmpeg
    firefox
    git
    helix
    inputs.agenix.packages.${pkgs.system}.default
    inputs.zen-browser.packages."${system}".default
    mesa
    mpv
    ouch
    pueue
    ripgrep
    # rustdesk
    sendme
    skim
    tree
    wezterm
    wget
    zstd
  ];
  programs.partition-manager.enable = lib.mkDefault true;

  # programs.nh = {
  #   enable = true;
  # };

  programs.firefox.enable = true;
  programs.firefox.policies = {
    DisablePocket = true;
    PasswordManagerEnabled = false;
    NoDefaultBookmarks = false;
  };
  programs.firefox.preferences = {
    "media.ffmpeg.vaapi.enabled" = true;

    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "widget.use-xdg-desktop-portal.location" = 1;
    "widget.use-xdg-desktop-portal.mime-handler" = 1;
    "widget.use-xdg-desktop-portal.open-uri" = 1;
    "widget.use-xdg-desktop-portal.settings" = 1;

    "accessibility.browsewithcaret_shortcut.enabled" = false;
    "browser.bookmarks.restore_default_bookmarks" = false;
  };

  hardware.graphics.enable = true;
  # hardware.opengl = {
  #   enable = true;
  #   extraPackaged = with pkgs; [
  #     libvdpau-va-gl
  #   ];
  # };
  services.xserver.enable = lib.mkDefault true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.xkb.layout = "us";
  systemd.services.display-manager.restartIfChanged = false;
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa
    kdePackages.konsole
    kdePackages.gwenview
    kdePackages.kate
    xterm
  ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
  ];
  programs.ssh.startAgent = true;

  services.printing.enable = lib.mkDefault true;
  services.printing.drivers = with pkgs; [gutenprint gutenprintBin];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  services.tailscale.enable = true;
  services.resolved.enable = true;
  networking.wireless.iwd = {
    enable = true;
    settings.IPv6.Enabled = true;
    settings.Settings.AutoConnect = true;
  };

  services.smartd.enable = true;
  # services.btrfs.autoScrub.enable = lib.mkDefault true;

  # hardware.pulseaudio.enable = lib.mkDefault false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = lib.mkDefault true;
  };

  security.sudo-rs.enable = true;
  security.sudo.enable = false;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
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

  time.timeZone = lib.mkDefault "US/Pacific";
  # services.automatic-timezoned.enable = lib.mkDefault true;
  # i18n.defaultLocale = "en_US.UTF-8";
  # i18n.extraLocaleSettings = {
  #   LC_CTYPE = "en_US.UTF-8";
  #   LC_MESSAGES = "en_US.UTF-8";
  #   LC_ALL = "en_US.UTF-8";
  # };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.loader.timeout = lib.mkForce 1;
  # boot.supportedFilesystems = ["ntfs" "btrfs"];
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = lib.mkDefault true;
  # hardware.bluetooth.settings.General.Experimental = true;

  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    # adding logged in users allows for passwordless root
    # trusted-users = ["root"];
    system-features = [
      "benchmark"
      "big-parallel"
      "gccarch-znver3"
      "gccarch-znver4"
      "kvm"
      "nixos-test"
    ];
  };
  nixpkgs.config = {allowUnfree = true;};
  nix.nixPath = ["nixpkgs=${pkgs.path}"];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = lib.mkDefault "23.05";
}
