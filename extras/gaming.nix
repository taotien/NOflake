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
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  users = {groups.game = {};};
  security.pam.loginLimits = [
    {
      domain = "@game";
      type = "-";
      item = "nice";
      value = -20;
    }
  ];

  environment.etc = let
    json = pkgs.formats.json {};
  in {
    "pipewire/pipewire.conf.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
      context.properties = {
        # default.allowed-rates = []
        default.clock.rate = 44100;
        default.clock.quantum = 24;
        default.clock.min-quantum = 24;
        default.clock.max-quantum = 24;
      };
    };
    "pipewire/pipewire-pulse.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min.req = "24/44100";
            pulse.default.req = "24/44100";
            pulse.max.req = "24/44100";
            pulse.min.quantum = "24/44100";
            pulse.max.quantum = "24/44100";
          };
        }
      ];
      stream.properties = {
        node.latency = "24/44100";
        resample.quality = 1;
      };
    };
  };
}
