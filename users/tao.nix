{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.tao.packages = with pkgs; [
    man-pages
    man-pages-posix
    gurk-rs
    # davinci-resolve
    nufmt
    freerdp
    nixos-anywhere
    cloud-hypervisor
    # fractal
    # kdeconnect
    # libsForQt5.kcharselect
    # mendeley
    # slack
    # tectonic
    # texlab
    # toastify
    # wkhtmltopdf
    appimage-run
    aspell
    aspellDicts.en
    bottles
    boxxy
    # calibre
    darktable
    deluge
    discord
    inputs.plasma-manager.packages.${pkgs.system}.default
    jellyfin-media-player
    jellyfin-mpv-shim
    kdePackages.plasma-vault
    keepassxc
    leetcode-cli
    miniserve
    nushell
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
    snapper
    starship
    syncthingtray
    taskwarrior3
    thunderbird
    typst
    typst-fmt
    typst-lsp
    tinymist
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

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  # virtualisation.virtualbox.host = {
  #   enable = true;
  #   enableExtensionPack = true;
  # };

  age.secrets.syncthing-NOcomputer.file = ../secrets/syncthing-NOcomputer.age;
  age.secrets.syncthing-NOlaptop.file = ../secrets/syncthing-NOlaptop.age;
  age.secrets.syncthing-uwuraid.file = ../secrets/syncthing-uwuraid.age;
  services.syncthing = {
    enable = true;
    user = "tao";
    dataDir = "/home/tao/sync";
    configDir = "/home/tao/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
    settings = {
      devices = {
        # we do a lil anti-patterns https://github.com/ryantm/agenix?tab=readme-ov-file#builtinsreadfile-anti-pattern
        # bootstrap by commenting out devices first and rebuild switch impurely
        "nocomputer".id = builtins.readFile config.age.secrets.syncthing-NOcomputer.path;
        "nolaptop".id = builtins.readFile config.age.secrets.syncthing-NOlaptop.path;
        "uwuraid".id = builtins.readFile config.age.secrets.syncthing-uwuraid.path;
      };
      folders = let
        devs = [
          "nocomputer"
          "nolaptop"
          "uwuraid"
        ];
      in {
        # "documents" = {
        #   path = "/home/tao/documents";
        #   devices = devs;
        # };
        "pictures" = {
          path = "/home/tao/pictures";
          devices = devs;
        };
        "projects" = {
          path = "/home/tao/projects";
          devices = devs;
        };
        "school" = {
          path = "/home/tao/school";
          devices = devs;
        };
        "sync" = {
          path = "/home/tao/sync";
          devices = devs;
        };
        # "work" = {
        #   path = "/home/tao/work";
        #   devices = devs;
        # };
      };
    };
  };

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
        if lib.nixosSystem == "NOlaptop"
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

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    ibm-plex
    cooper-hewitt
  ];

  documentation.enable = true;

  age.secrets.password-tao.file = ../secrets/syncthing-uwuraid.age;
  users.users.tao = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.password-tao.path;
    extraGroups = ["audio" "video" "wheel" "libvirtd" "dialout" "game"];
    shell = pkgs.nushell;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = ".hm-bak";
  home-manager.users.tao = import ./tao/HOME.nix {inherit inputs pkgs lib;};
}
