{
    pkgs,
    lib,
    inputs,
    config,
    ...
}: let
    pkgs-last-building = inputs.nixpkgs-last-building.legacyPackages.${pkgs.system};
in {
    users.users.vy.packages =
        /*
           (with pkgs-last-building; [
                oculante # https://nixpk.gs/pr-tracker.html?pr=502921
            ])
    ++ (
    */
        with pkgs; [
            audacity
            cosmic-store
            google-chrome
            jellyfin-media-player
            onlyoffice-desktopeditors
            rnote
            signal-desktop
            signal-desktop
            snapper
            syncthingtray
            toastify
            yt-dlp
            zoom-us
        ];
    programs.kdeconnect.enable = true;

    services.flatpak.enable = true;

    services.snapper.configs = {
        home = {
            SUBVOLUME = "/home";
            ALLOW_USERS = ["vy"];
            TIMELINE_CREATE = true;
            TIMELINE_CLEANUP = true;
            TIMELINE_LIMIT_HOURLY = 5;
            TIMELINE_LIMIT_DAILY = 7;
        };
    };
    services.snapper.snapshotInterval = "*:0/5";

    users.users.vy = {
        isNormalUser = true;
        extraGroups = ["wheel" "audio" "video"];
        shell = pkgs.nushell;
    };

    users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKLOGhoTauV+yBide0qYQzZ/0rRw7ImfrOTvuZxjIFl"
    ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.verbose = true;
    home-manager.backupFileExtension = ".hm-bak";
    home-manager.users.vy = import ./vy/HOME.nix {inherit inputs pkgs lib config;};
}
