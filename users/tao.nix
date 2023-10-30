{ pkgs, ... }: {
  users.users.tao.packages = with pkgs; [
    # enchant
    # expressvpn
    # fractal
    # libftdi
    # libusb
    # mdbook
    # nuspell
    # partition-manager
    # pkg-config
    # slack
    appimage-run
    aspell
    aspellDicts.en
    bottles
    # cider
    darktable
    deluge
    discord
    gh
    jellyfin-media-player
    jellyfin-mpv-shim
    keepassxc
    libsForQt5.kcharselect
    libsForQt5.kdeconnect-kde
    obs-studio
    ocs-url
    onlyoffice-bin
    ripgrep-all
    rustdesk
    snapper
    tectonic
    texlab
    tio
    typst-lsp
    unstable.nushell
    unstable.oculante
    unstable.prusa-slicer
    unstable.starship
    unstable.typst
    unstable.wezterm
    unstable.joshuto
    unstable.yazi
    virt-manager
    zathura
    zoom-us
    zoxide
    onefetch
    thunderbird
    birdtray
    syncthingtray
    unstable.pandoc
  ];
  programs.mosh.enable = true;
  environment.shells = with pkgs; [ unstable.nushell ];

  # services.expressvpn.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  services.syncthing = {
    enable = true;
    user = "tao";
    dataDir = "/home/tao/Sync";
    configDir = "/home/tao/.config/syncthing";
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  users.users.tao = {
    isNormalUser = true;
    extraGroups = [ "video" "wheel" "libvirtd" "dialout" "scanner" "lp" ];
    shell = pkgs.unstable.nushell;
  };

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-chewing fcitx5-chinese-addons fcitx5-rime ];
  # };
}
