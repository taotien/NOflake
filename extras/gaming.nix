{pkgs, ...}: {
  # { pkgs, aagl, ... }: {
  # imports = [ aagl.nixosModules.default ];
  # nix.settings = aagl.nixConfig;
  # programs.honkers-railway-launcher.enable = true;
  # nixpkgs.config.permittedInsecurePackages = [
  #   "electron-24.8.6"
  #   # "electron-12.2.3"
  # ];

  environment.systemPackages = with pkgs; [
    # parsec-bin
    heroic
    lutris
    mangohud
    prismlauncher
    protonup
    wine
    # yuzu
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = false;
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

  # services.pipewire.enable = false;
  services.pipewire.extraConfig = {
    pipewire."99-low-latency" = {
      context.properties = {
        default.allowed-rates = [44100 48000 96000];
        default.clock.rate = 192000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
      context.modules = [
        {
          name = "libpipewire-module-rt";
          args = {
            nice.level = -12;
            rt.prio = 89;
            rt.time.soft = 200000;
            rt.time.hard = 200000;
          };
          flags = ["ifexists nofail"];
        }
      ];
    };
    pipewire-pulse."99-low-latency" = {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min.req = "32/192000";
            pulse.default.req = "32/192000";
            pulse.max.req = "32/192000";
            pulse.min.quantum = "32/192000";
            pulse.max.quantum = "32/192000";
          };
        }
      ];
      stream.properties = {
        node.latency = "32/192000";
        resample.quality = 1;
      };
    };
  };
}
