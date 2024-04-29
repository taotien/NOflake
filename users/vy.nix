{pkgs, ...}: {
  users.users.vy.packages = with pkgs; [
    audacity
    cosmic-store
    jellyfin-media-player
    keepassxc
    onlyoffice-bin
    snapper
    syncthingtray
    yt-dlp
    zoom-us
  ];
  programs.kdeconnect.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts-cjk
    noto-fonts-color-emoji
  ];

  services.flatpak.enable = true;

  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = ["vy"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = "5";
      TIMELINE_LIMIT_DAILY = "7";
    };
  };
  services.snapper.snapshotInterval = "*:0/5";

  users.users.vy = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "video"];
  };
}
