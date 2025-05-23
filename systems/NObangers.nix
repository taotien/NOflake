{
    config,
    pkgs,
    lib,
    ...
}: {
    environment.systemPackages = with pkgs; [
        raspberrypi-eeprom
    ];
    programs.partition-manager.enable = false;

    services.printing.enable = false;
    i18n.inputMethod = {};

    services.xserver.enable = false;
    services.desktopManager.plasma6.enable = false;

    hardware.raspberry-pi."4" = {
        bluetooth.enable = true;
        audio.enable = true;
    };

    boot.loader.systemd-boot.enable = false;
    boot.loader.efi.canTouchEfiVariables = false;

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-label/NIXOS_SD";
            fsType = "ext4";
            options = ["noatime"];
        };
    };

    nix.buildMachines = [
        {
            hostName = "nolaptop";
            systems = ["x86_64-linux" "i686-linux"];
            supportedFeatures = [
                "benchmark"
                "big-parallel"
                "gccarch-znver4"
                "kvm"
                "nixos-test"
            ];
        }
    ];
    nix.extraOptions = ''
        builders-use-substitutes = true
    '';
    nix.distributedBuilds = true;

    networking.hostName = "NObangers";
    nixpkgs.hostPlatform = "aarch64-linux";
    system.stateVersion = "23.11";
}
