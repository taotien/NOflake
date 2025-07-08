{pkgs, ...}: {
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    # aagl.inputs.nixpkgs.follows = "nixpkgs";

    environment.systemPackages = with pkgs; [
        osu-lazer-bin
        easyeffects
        # parsec-bin
        # yuzu # nintendo can suck the shit out of my asshole
        gamemode
        heroic
        lutris
        mangohud
        prismlauncher
        protonup-qt
        r2modman
        wine
        temurin-jre-bin-17
        graalvm-ce
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
