{
  inputs,
  config,
  pkgs,
  ...
}: {
  users.users.tao.packages = with pkgs; [
    # enchant
    # fractal
    # joshuto
    # libftdi
    # libusb
    # mendeley
    # nuspell
    # ocs-url
    oculante
    # onefetch
    # slack
    # tectonic
    # texlab
    # tio
    # toastify
    # vial
    # wkhtmltopdf
    # yazi
    appimage-run
    aspell
    aspellDicts.en
    bottles
    calibre
    darktable
    deluge
    ffmpeg
    firefox
    jellyfin-media-player
    jellyfin-mpv-shim
    keepassxc
    leetcode-cli
    libsForQt5.kcharselect
    libsForQt5.kdeconnect-kde
    libsForQt5.plasma-integration
    libsForQt5.plasma-vault
    miniserve
    mpv
    nushell
    obs-studio
    onlyoffice-bin
    pandoc
    pipe-rename
    prusa-slicer
    qmk
    qmk-udev-rules
    qmk_hid
    ripgrep-all
    snapper
    starship
    syncthingtray
    taskwarrior
    thunderbird
    typst
    typst-fmt
    typst-lsp
    virt-manager
    wezterm
    yt-dlp
    zathura
    zoom-us
    zoxide
    discord
  ];
  # programs.adb.enable = true;
  environment.shells = with pkgs; [nushell];

  # virt
  programs.dconf.enable = true;
  virtualisation.libvirtd.enable = true;

  services.syncthing = {
    enable = true;
    user = "tao";
    dataDir = "/home/tao/Sync";
    configDir = "/home/tao/.config/syncthing";
  };

  hardware.keyboard.qmk.enable = true;
  # services.udev.extraRules = ''
  #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  # '';

  # obs virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  # stylix.autoEnable = false;
  # stylix.image = /home/tao/Pictures/Wallpapers/DJI_0121.JPG;
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  # stylix.fonts = with pkgs; {
  #   monospace = {
  #     package = nerdfonts.override {fonts = ["FiraCode"];};
  #     name = "FiraCode Nerd Font";
  #   };
  # };
  # stylix.targets = {
  #   console.enable = true;
  # };
  # home-manager.sharedModules = [
  #   {
  #     stylix.targets = {
  #       bat.enable = true;
  #       # firefox.enable = true;
  #       # helix.enable = true;
  #       kde.enable = true;
  #       nushell.enable = true;
  #       # wezterm.enable = true;
  #       zathura.enable = true;
  #       zellij.enable = true;
  #     };
  #   }
  # ];

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
    noto-fonts-cjk
    noto-fonts-color-emoji
  ];

  users.users.tao = {
    isNormalUser = true;
    extraGroups = ["audio" "video" "wheel" "libvirtd" "dialout" "game"];
    shell = pkgs.nushell;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = ".hm-bak";
  home-manager.users.tao = import ./tao/HOME.nix {inherit inputs pkgs;};
}
