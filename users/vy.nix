{pkgs, lib, inputs, config, ...}: {
  users.users.vy.packages = with pkgs; [
    oculante
    rnote
    audacity
    cosmic-store
    jellyfin-media-player
    keepassxc
    onlyoffice-bin
    signal-desktop
    snapper
    syncthingtray
    yt-dlp
    zoom-us
    toastify
  ];
  programs.kdeconnect.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  services.flatpak.enable = true;

  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = ["vy"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 5;
      TIMELINE_LIMIT_DAILY = 7;
    };
  };
  services.snapper.snapshotInterval = "*:0/5";

  users.users.vy = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "video"];
    shell = pkgs.nushell;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKLOGhoTauV+yBide0qYQzZ/0rRw7ImfrOTvuZxjIFl"
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = ".hm-bak";
  home-manager.users.vy = import ./vy/HOME.nix {inherit inputs pkgs lib config;};
}
