{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        temurin-jre-bin-17
    ];
    networking.firewall.allowedTCPPorts = [25565];

    services.snapper.configs = {
        home = {
            SUBVOLUME = "/home";
            ALLOW_USERS = ["mc"];
            TIMELINE_CREATE = true;
            TIMELINE_CLEANUP = true;
            TIMELINE_LIMIT_HOURLY = "5";
            TIMELINE_LIMIT_DAILY = "7";
        };
    };
    services.snapper.snapshotInterval = "*:0/5";
}
