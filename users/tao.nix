{ inputs, pkgs, ... }: {
  users.users.tao.packages = with pkgs; [
    miniserve
    # wkhtmltopdf
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
    # slack
    # oculante
    # joshuto
    # yazi
    # gh
    # tio
    appimage-run
    aspell
    aspellDicts.en
    # birdtray
    bottles
    calibre
    darktable
    deluge
    discord
    jellyfin-media-player
    jellyfin-mpv-shim
    keepassxc
    leetcode-cli
    libsForQt5.kcharselect
    libsForQt5.kdeconnect-kde
    libsForQt5.plasma-vault
    # mendeley
    nushell
    obs-studio
    # ocs-url
    onefetch
    onlyoffice-bin
    pandoc
    prusa-slicer
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

  # home-manager.useUserPackages = false;
  home-manager.useGlobalPkgs = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = ".hm-bak";
  home-manager.users.tao = (import ./tao/home.nix { inherit inputs pkgs; });
}
