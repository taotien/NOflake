{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.tao.packages = with pkgs; [
    # boxxy
    calibre
    # carapace
    # cloud-hypervisor
    # davinci-resolve
    # fractal
    # freerdp
    # inputs.plasma-manager.packages.${pkgs.system}.default
    # jellyfin-mpv-shim
    # libsForQt5.kcharselect
    # mendeley
    # piper
    # slack
    # tectonic
    # texlab
    # thunderbird
    # wkhtmltopdf
    appimage-run
    aspell
    aspellDicts.en
    bottles
    darktable
    deluge
    discord
    freecad-wayland
    gocryptfs
    gurk-rs
    jellyfin-media-player
    # kdePackages.plasma-vault
    keepassxc
    # leetcode-cli
    man-pages
    man-pages-posix
    miniserve
    mousai
    nix-output-monitor
    nixos-anywhere
    nufmt
    nushell
    nvd
    obs-studio
    oculante
    onlyoffice-bin
    pandoc
    pipe-rename
    prusa-slicer
    qmk
    qmk-udev-rules
    qmk_hid
    ripgrep-all
    signal-desktop
    slack
    snapper
    starship
    syncthingtray
    taskwarrior3
    tinymist
    toastify
    typst
    usbutils
    vial
    wezterm
    wl-clipboard-rs
    yt-dlp
    zathura
    zellij
    zoom-us
    zoxide
  ];
  programs.adb.enable = true;
  programs.kdeconnect.enable = true;
  environment.shells = with pkgs; [nushell];

  # virtualisation.libvirtd.enable = true;
  # virtualisation.libvirtd.qemu.swtpm.enable = true;
  # virtualisation.spiceUSBRedirection.enable = true;
  # programs.virt-manager.enable = true;

  # virtualisation.virtualbox.host = {
  #   enable = true;
  #   enableExtensionPack = true;
  # };

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     options.services.snapper.configs = prev.options.services.snapper.configs.overrideAttrs (old: {
  #       configOptions.FSTYPE = lib.mkOption {
  #         type = lib.types.enum ["btrfs" "bcachefs"];
  #       };
  #     });
  #   })
  # ];

  disabledModules = ["services/misc/snapper.nix"];
  imports = [../extras/snapper.nix];
  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      # FSTYPE = "bcachefs";
      FSTYPE =
        if lib.strings.hasPrefix "NOlaptop" (builtins.readFile /etc/hostname)
        then "bcachefs"
        else "btrfs";
      ALLOW_USERS = ["tao"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 5;
      TIMELINE_LIMIT_DAILY = 7;
    };
  };
  services.snapper.snapshotInterval = "*:0/5";

  hardware.keyboard.qmk.enable = true;
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
  # services.ratbagd.enable = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  fonts.packages = with pkgs; [
    # (nerdfonts.override {fonts = ["FiraCode"];})
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    ibm-plex
    cooper-hewitt
  ];

  documentation.enable = true;

  # age.secrets.password-tao.file = ../secrets/syncthing-uwuraid.age;
  users.users.tao = {
    isNormalUser = true;
    # hashedPasswordFile = config.age.secrets.password-tao.path;
    extraGroups = ["audio" "video" "wheel" "libvirtd" "dialout" "game"];
    shell = pkgs.nushell;
  };

  age.secrets.syncthing-NOcomputer.file = ../secrets/syncthing-NOcomputer.age;
  age.secrets.syncthing-NOlaptop.file = ../secrets/syncthing-NOlaptop.age;
  age.secrets.syncthing-uwuraid.file = ../secrets/syncthing-uwuraid.age;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = ".hm-bak";
  home-manager.users.tao = import ./tao/HOME.nix {inherit inputs pkgs lib config;};
}
