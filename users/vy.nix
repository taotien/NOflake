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
  
  users.users.vy = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "video"];
  };
}
