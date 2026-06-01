{
    config,
    inputs,
    lib,
    pkgs,
    modulesPath,
    ...
}: {
    services.fwupd.enable = true;

    nixpkgs.overlays = [
        (final: prev: {
            inherit
                (prev.lixPackageSets.stable)
                nixpkgs-review
                nix-eval-jobs
                nix-fast-build
                colmena
                ;
        })
    ];

    nix.package = lib.mkIf (config.networking.hostName == "NOcomputer") pkgs.lixPackageSets.stable.lix;

    environment.systemPackages = with pkgs; [
        # keep-sorted start
        bat
        bottom
        cachix
        cifs-utils
        dumbpipe
        dust
        exfatprogs
        fastfetch
        ffmpeg
        firefox
        git
        helix
        inputs.agenix.packages.${pkgs.system}.default
        inputs.zen-browser.packages."${system}".default
        jujutsu
        mesa
        mpv
        ouch
        pueue
        ripgrep
        rustdesk
        sendme
        skim
        smartmontools
        tree
        waypipe
        wezterm
        wget
        zellij
        zstd
        # keep-sorted end
    ];
    programs.partition-manager.enable = lib.mkDefault true;
    programs.pmount.enable = lib.mkDefault true;
    programs.mosh.enable = lib.mkDefault true;

    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
        # keep-sorted start
        cooper-hewitt
        ibm-plex
        inconsolata
        iosevka
        libertine
        linux-libertine-g
        nerd-fonts.fira-code
        nerd-fonts.iosevka-term
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        # keep-sorted end
    ];
    system.userActivationScripts.installFonts = ''
        mkdir -p ~/.local/share/fonts
        find ${pkgs.noto-fonts-cjk-sans}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.noto-fonts-cjk-serif}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.cooper-hewitt}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.ibm-plex}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.inconsolata}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.iosevka}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.libertine}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.linux-libertine-g}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.nerd-fonts.fira-code}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.nerd-fonts.iosevka-term}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        find ${pkgs.noto-fonts-color-emoji}/share/fonts \
          -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.ttc" \) \
          -exec cp -f {} ~/.local/share/fonts/ \;
        fc-cache -fv
    '';

    hardware.graphics.enable = true;
    # hardware.opengl = {
    #   enable = true;
    #   extraPackaged = with pkgs; [
    #     libvdpau-va-gl
    #   ];
    # };
    services.xserver.enable = lib.mkDefault true;
    services.xserver.excludePackages = [pkgs.xterm];
    services.xserver.xkb.layout = "us";
    systemd.services.display-manager.restartIfChanged = false;
    services.desktopManager.cosmic.enable = lib.mkDefault true;
    services.displayManager.cosmic-greeter.enable = lib.mkDefault true;
    services.system76-scheduler.enable = false;
    environment.cosmic.excludePackages = with pkgs; [
        cosmic-edit
        cosmic-player
        cosmic-term
        cosmic-wallpapers
    ];
    # xdg.portal.enable = lib.mkForce true;

    services.flatpak.enable = true;
    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [
    ];
    programs.ssh.startAgent = true;
    services.gnome.gcr-ssh-agent.enable = false;

    services.printing.enable = lib.mkDefault true;
    services.printing.drivers = with pkgs; lib.mkDefault [gutenprint gutenprintBin hplip];
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    services.tailscale.enable = true;
    services.resolved.enable = true;
    networking.wireless.iwd = {
        enable = true;
        settings.IPv6.Enabled = true;
        settings.Settings.AutoConnect = true;
    };
    services.smartd = {
        enable = true;
        notifications.systembus-notify.enable = true;
    };

    # services.btrfs.autoScrub.enable = lib.mkDefault true;
    services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = ["/"];
    };

    security.rtkit.enable = true;
    services.pipewire = {
        enable = lib.mkDefault true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = lib.mkDefault true;
    };

    security.sudo-rs.enable = true;
    security.sudo.enable = false;

    i18n.inputMethod = {
        enable = lib.mkDefault true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
            fcitx5-gtk
            fcitx5-mozc
            fcitx5-rime
            rime-ice
        ];
    };

    environment.variables = {
        EDITOR = "hx";
        VISUAL = "hx";
        PAGER = "bat";
        SKIM_DEFAULT_COMMAND = "rg --files";
    };
    environment.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
        PAGER = "bat";
        SKIM_DEFAULT_COMMAND = "rg --files";
    };

    time.timeZone = lib.mkDefault "US/Pacific";
    # services.automatic-timezoned.enable = lib.mkDefault true;
    # i18n.defaultLocale = "en_US.UTF-8";
    # i18n.extraLocaleSettings = {
    #   LC_CTYPE = "en_US.UTF-8";
    #   LC_MESSAGES = "en_US.UTF-8";
    #   LC_ALL = "en_US.UTF-8";
    # };

    # systemd.settings.Manager = ''
    #   DefaultTimeoutStopSec=15s
    # '';
    # systemd.settings.Manager = "";

    zramSwap = {
        enable = true;
        algorithm = "zstd";
    };

    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
    boot.loader.timeout = lib.mkForce 1;
    # boot.supportedFilesystems = ["ntfs" "btrfs"];
    hardware.enableAllFirmware = true;
    hardware.bluetooth = {
        enable = lib.mkDefault true;
        settings.General = {
            # ControllerMode = "bredr"; # Fix frequent Bluetooth audio dropouts
            Experimental = true;
            FastConnectable = true;
        };
    };
    # hardware.bluetooth.settings.General.Experimental = true;

    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    programs.nix-ld = {
        enable = true;
    };

    nix.settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        # adding logged in users allows for passwordless root
        trusted-users = ["root" "@wheel"];
        system-features = [
            "benchmark"
            "big-parallel"
            "gccarch-znver3"
            "gccarch-znver4"
            "kvm"
            "nixos-test"
        ];
    };
    nixpkgs.config = {allowUnfree = true;};
    nix.nixPath = ["nixpkgs=${pkgs.path}"];
    nix.gc = {
        automatic = true;
        options = "--delete-older-than 7d";
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    system.stateVersion = lib.mkDefault "23.05";
}
