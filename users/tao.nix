{
  inputs,
  config,
  pkgs,
  ...
}: {
  users.users.tao.packages = with pkgs; [
    # birdtray
    # cider
    # enchant
    # expressvpn
    # fractal
    # gh
    # libftdi
    # libusb
    # mdbook
    # mendeley
    # nuspell
    # ocs-url
    # oculante
    # partition-manager
    # slack
    # tio
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
    discord
    gpt4all-chat
    jellyfin-media-player
    jellyfin-mpv-shim
    joshuto
    keepassxc
    leetcode-cli
    libsForQt5.kcharselect
    libsForQt5.kdeconnect-kde
    libsForQt5.plasma-vault
    miniserve
    nushell
    obs-studio
    # ollama
    onefetch
    onlyoffice-bin
    pandoc
    plasma-integration
    prusa-slicer
    pueue
    qmk
    qmk-udev-rules
    ripgrep-all
    snapper
    starship
    syncthingtray
    tectonic
    texlab
    thunderbird
    typst
    typst-fmt
    typst-lsp
    virt-manager
    wezterm
    zathura
    zoom-us
    zoxide
  ];
  # programs.adb.enable = true;
  # programs.mosh.enable = true;
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
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # obs virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
    noto-fonts-cjk
    noto-fonts-color-emoji
  ];

  users.users.tao = {
    isNormalUser = true;
    extraGroups = ["video" "wheel" "libvirtd" "dialout" "game"];
    shell = pkgs.nushell;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = ".hm-bak";
  home-manager.users.tao = import ./tao/home.nix {inherit inputs pkgs;};
}
