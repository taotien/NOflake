{
    pkgs,
    inputs,
    ...
}: let
    pkgs-last-building = inputs.nixpkgs-last-building.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    # aagl.inputs.nixpkgs.follows = "nixpkgs";

    # scx_lavd causes ~21s RCU-stall freezes under gaming workloads; see extras/dev.nix
    # services.scx.scheduler = "scx_lavd"; # default is "scx_rustland"

    services.lsfg-vk = {
        enable = true;
        ui.enable = true;
    };

    environment.systemPackages =
        /*
       (with pkgs-last-building; [
        # lutris
    ])
    ++
    */
        with pkgs; [
            # keep-sorted start
            # parsec-bin
            # yuzu # nintendo can suck the shit out of my asshole
            easyeffects
            gamemode
            graalvmPackages.graalvm-ce
            heroic
            mangohud
            osu-lazer-bin
            prismlauncher
            protonup-qt
            r2modman
            temurin-jre-bin-17
            wine
            # keep-sorted end
        ];

    # ~/.config/pipewire/pipewire.conf pins the graph to 96kHz for the FiiO. THE FINALS
    # (proton, reports application.name "THE FINALS") renders 48kHz and winepulse asks for a tiny buffer,
    # so it gets resampled at a ~0.3ms quantum and crackles. While its stream is
    # active, force the graph (and so the DAC) to 48kHz with a sane quantum; pipewire
    # drops back to 96kHz once the stream goes away.
    services.pipewire.extraConfig.pipewire-pulse."92-games" = let
        games = [
            {"application.name" = "THE FINALS";}
        ];
    in {
        "pulse.rules" = [
            {
                matches = games;
                actions.update-props = {
                    "pulse.min.req" = "1024/48000";
                    "pulse.min.quantum" = "1024/48000";
                };
            }
        ];
        "stream.rules" = [
            {
                matches = games;
                actions.update-props = {
                    "node.force-rate" = 48000;
                    "node.latency" = "1024/48000";
                };
            }
        ];
    };

    networking.firewall.allowedTCPPorts = [25565];

    programs.steam = {
        enable = true;
        # extest.enable only preloads the i686 build, but the on-screen keyboard
        # is driven by the 64-bit steamwebhelper; preload both (ld.so skips the
        # wrong-class one per process).
        package = pkgs.steam.override {
            extraEnv.LD_PRELOAD = "${pkgs.pkgsi686Linux.extest}/lib/libextest.so:${pkgs.extest}/lib/libextest.so";
        };
        # remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    security.pam.loginLimits = [
        {
            domain = "@game";
            type = "-";
            item = "nice";
            value = -20;
        }
    ];
    security.sudo-rs.extraRules = [
        {
            commands = [
                {
                    command = "${pkgs.systemd}/bin/bootctl set-oneshot auto-windows";
                    options = ["NOPASSWD"];
                }
            ];
            groups = ["wheel"];
        }
    ];
}
