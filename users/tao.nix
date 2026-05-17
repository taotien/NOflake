{
    inputs,
    config,
    pkgs,
    lib,
    ...
}: let
    pkgs-last-building = inputs.nixpkgs-last-building.legacyPackages.${pkgs.system};
in {
    users.users.tao.packages =
        (with pkgs-last-building; [
            # oculante # https://nixpk.gs/pr-tracker.html?pr=502921
        ])
        ++ (with pkgs; [
            # keep-sorted start sticky_comments=no
            # android-tools
            # bottles
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
            appimage-run
            aspell
            aspellDicts.en
            bitwarden-cli
            bitwarden-desktop
            calibre
            darktable
            deluge
            discord
            element-desktop
            feedr
            forgejo-cli
            freecad-wayland
            gocryptfs
            grayjay
            jellyfin-mpv-shim
            man-pages
            man-pages-posix
            miniserve
            mousai
            nix-output-monitor
            nufmt
            nushell
            nvd
            obs-studio
            oculante
            onlyoffice-desktopeditors
            openscad
            pandoc
            pipe-rename
            printrun
            prusa-slicer
            qmk
            qmk-udev-rules
            qmk_hid
            ripgrep-all
            rqbit
            signal-desktop
            slack
            snapper
            sniffnet
            starship
            syncplay
            tinymist
            toastify
            transmission_4-gtk
            typst
            typstyle
            usbutils
            vial
            wezterm
            wl-clipboard-rs
            yt-dlp
            zathura
            zoom-us
            zotero
            zoxide
            # keep-sorted end
        ]);
    virtualisation.waydroid = {
        enable = true;
        package = pkgs.waydroid-nftables;
    };

    environment.shells = with pkgs; [nushell];

    documentation.enable = true;

    # virtualisation.libvirtd.enable = true;
    # virtualisation.libvirtd.qemu.swtpm.enable = true;
    # virtualisation.spiceUSBRedirection.enable = true;
    # programs.virt-manager.enable = true;

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
        extraGroups = ["audio" "video" "wheel" "libvirtd" "dialout" "game"];
        shell = pkgs.nushell;
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
