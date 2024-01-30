{ pkgs, ... }: {
  users.users.tao.packages = with pkgs; [
    leetcode-cli
    typst-fmt
    mendeley
    # wkhtmltopdf
    calibre
    qmk
    qmk-udev-rules
    # vial
    # cider
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
    birdtray
    bottles
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
    onefetch
    onlyoffice-bin
    ripgrep-all
    snapper
    syncthingtray
    tectonic
    texlab
    thunderbird
    tio
    typst-lsp
    joshuto
    nushell
    # oculante
    pandoc
    prusa-slicer
    starship
    typst
    wezterm
    yazi
    virt-manager
    zathura
    zoom-us
    zoxide
  ];
  # programs.adb.enable = true;
  programs.mosh.enable = true;
  environment.shells = with pkgs; [ nushell ];

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
  hardware.keyboard.qmk.enable = true;

  # services.expressvpn.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  services.syncthing = {
    enable = true;
    user = "tao";
    dataDir = "/home/tao/Sync";
    configDir = "/home/tao/.config/syncthing";
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts-cjk
    noto-fonts-color-emoji
  ];

  users.users.tao = {
    isNormalUser = true;
    extraGroups = [ "video" "wheel" "libvirtd" "dialout" "game" ];
    shell = pkgs.nushell;
  };


  security.sudo-rs.enable = true;
  security.sudo-rs.extraRules = [{
    commands = [
      { command = "${pkgs.systemd}/bin/bootctl set-oneshot auto-windows"; options = [ "NOPASSWD" ]; }
    ];
    groups = [ "wheel" ];
  }];

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-chewing fcitx5-chinese-addons fcitx5-rime ];
  # };

  # imports = [ (import "${home-manager}/nixos") ];
  # imports = [ home-manager.nixosModules.home-manager ];

  # home-manager.nixosModules.home-manager
  # {
  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;
  #   home-manager.users.tao = import ./users/tao.nix;
  # }
  # home.username = "tao";

  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = false;
  home-manager.verbose = true;
  home-manager.backupFileExtension = ".hm-bak";
  home-manager.users.tao = import ./tao/home.nix;
}
