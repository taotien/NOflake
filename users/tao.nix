{ pkgs, ... }: {
  users.users.tao.packages = with pkgs; [
    mendeley
    unstable.wkhtmltopdf
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
    unstable.joshuto
    unstable.nushell
    # unstable.oculante
    unstable.pandoc
    unstable.prusa-slicer
    unstable.starship
    unstable.typst
    unstable.wezterm
    unstable.yazi
    virt-manager
    zathura
    zoom-us
    zoxide
  ];
  programs.mosh.enable = true;
  environment.shells = with pkgs; [ unstable.nushell ];
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

  security.sudo = {
    extraRules = [{
      commands = [
        {
          command = "${pkgs.systemd}/bin/bootctl set-oneshot auto-windows";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-chewing fcitx5-chinese-addons fcitx5-rime ];
  # };
}
