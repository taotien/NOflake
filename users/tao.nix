{
    inputs,
    config,
    pkgs,
    lib,
    ...
}: let
    punstable = import inputs.nixpkgs-unstable {
        inherit (pkgs) system;
        config.allowUnfree = true;
    };
in {
    nixpkgs.config.permittedInsecurePackages = [
        # "electron-39.8.10"
    ];

    users.users.tao.packages =
        (
            with punstable; [
                # keep-sorted start sticky_comments=no
                bottles
                discord
                forgejo-cli
                # grayjay
                inputs.zen-browser.packages."${system}".default
                nufmt
                nushell
                prusa-slicer
                signal-desktop
                slack
                typst
                typstyle
                wezterm
                yt-dlp
                # keep-sorted end
            ]
        )
        ++ (
            with pkgs; [
                freecad-wayland
                # keep-sorted start sticky_comments=no
                # bitwarden-desktop
                # boxxy
                # carapace
                # davinci-resolve
                # fractal
                # gurk-rs
                # jellyfin-media-player
                # nixos-anywhere
                # piper
                # syncthingtray
                # taskwarrior3
                # tectonic
                # texlab
                # thunderbird
                # wkhtmltopdf
                # zoom-us
                android-tools
                appimage-run
                aspell
                aspellDicts.en
                bitwarden-cli
                calibre
                darktable
                deluge
                element-desktop
                feedr
                gocryptfs
                jellyfin-mpv-shim
                man-pages
                man-pages-posix
                miniserve
                mousai
                nix-output-monitor
                nvd
                obs-studio
                oculante
                onlyoffice-desktopeditors
                openscad
                pandoc
                pipe-rename
                printrun
                qmk
                qmk-udev-rules
                qmk_hid
                ripgrep-all
                rqbit
                snapper
                sniffnet
                starship
                syncplay
                tinymist
                toastify
                transmission_4-gtk
                usbutils
                vial
                wl-clipboard-rs
                zathura
                zotero
                zoxide
                # keep-sorted end
            ]
        );
    programs.gphoto2.enable = true;
    virtualisation.waydroid = {
        enable = true;
        package = pkgs.waydroid-nftables;
    };

    environment.shells = [punstable.nushell];

    documentation.enable = true;
    # the NixOS manual's options.json build hits a third-party module option
    # that interpolates a flake input path without proper store context
    # ("builtins.derivation ... options.json ... without a proper context").
    # man pages etc. stay on via documentation.enable above.
    documentation.nixos.enable = false;

    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    programs.virt-manager.enable = true;

    # virtualisation.virtualbox.host = {
    #   enable = true;
    #   enableExtensionPack = true;
    # };

    disabledModules = ["services/misc/snapper.nix"];
    imports = [../extras/snapper.nix];
    services.snapper.configs = {
        home = {
            SUBVOLUME = "/home";
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
    services.ratbagd.enable = true;

    # boot = {
    #     extraModulePackages = with config.boot.kernelPackages; [
    #         v4l2loopback
    #     ];
    #     extraModprobeConfig = ''
    #         options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    #     '';
    # };
    # security.polkit.enable = true;
    programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
        package = pkgs.obs-studio.override {cudaSupport = true;};
    };

    users.users.tao = {
        isNormalUser = true;
        # hashedPasswordFile = config.age.secrets.password-tao.path;
        extraGroups = ["audio" "video" "wheel" "libvirtd" "dialout" "game" "camera"];
        shell = punstable.nushell;
    };
    age.secrets = {
        syncthing-NOcomputer.file = ../secrets/syncthing-NOcomputer.age;
        syncthing-NOlaptop.file = ../secrets/syncthing-NOlaptop.age;
        syncthing-uwuraid.file = ../secrets/syncthing-uwuraid.age;
    };
    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        verbose = true;
        backupFileExtension = ".hm-bak";
        overwriteBackup = true;
        extraSpecialArgs = {inherit inputs;};
        users.tao = import ./tao/HOME.nix;
    };
}
