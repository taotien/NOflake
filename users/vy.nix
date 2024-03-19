{pkgs, ...}: {
  users.users.vy.packages = with pkgs; [
    audacity
    firefox
    jellyfin-media-player
    keepassxc
    libsForQt5.kdeconnect-kde
    mpv
    onlyoffice-bin
    snapper
    syncthingtray
    wezterm
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
