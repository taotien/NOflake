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

    # THE FINALS (proton, reports application.name "THE FINALS") mixes at 48kHz and
    # winepulse asks for a tiny buffer. If the graph is already running at a higher
    # rate (e.g. hi-res music on the FiiO), the game gets resampled at a tiny quantum
    # and the high end turns scratchy. While its stream is active, force the graph
    # (and so the DAC) to 48kHz with a sane quantum.
    # Note winepulse opens its streams at pipewire-pulse's *default* rate, so
    # default.clock.rate must stay 48000 (see extras/fiio.nix), or wine resamples
    # 48k->96k itself before pipewire ever sees it.
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
