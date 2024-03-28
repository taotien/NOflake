{pkgs, ...}: {
  users.users.vy.packages = with pkgs; [
    audacity
    jellyfin-media-player
    keepassxc
    onlyoffice-bin
    snapper
    syncthingtray
    yt-dlp
    zoom-us
  ];

  fonts.packages = with pkgs; [
    noto-fonts-cjk
    noto-fonts-color-emoji
  ];

  users.users.vy = {
    isNormalUser = true;
    extraGroups = ["audio" "video"];
  };
}
