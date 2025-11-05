{pkgs, ...}: {
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    # aagl.inputs.nixpkgs.follows = "nixpkgs";

    services.lsfg-vk = {
        enable = true;
        ui.enable = true;
    };

    environment.systemPackages = with pkgs; [
        # keep-sorted start
        # parsec-bin
        # yuzu # nintendo can suck the shit out of my asshole
        easyeffects
        gamemode
        graalvmPackages.graalvm-ce
        heroic
        lutris
        mangohud
        osu-lazer-bin
        prismlauncher
        protonup-qt
        r2modman
        temurin-jre-bin-17
        wine
        # keep-sorted end
    ];

    networking.firewall.allowedTCPPorts = [25565];

    programs.steam = {
        enable = true;
        # remotePlay.openFirewall = true;
        # gamescopeSession.enable = false;
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
