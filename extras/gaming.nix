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
    yuzu
  ];

  # programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = false;
  };
  # programs.gamemode.enable = true;
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

  # services.pipewire = {
  #   enable = true;
  # };
  # environment.etc = let
  #   json = pkgs.formats.json {};
  # in {
  #   "pipewire/pipewire.conf.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
  #     context.properties = {
  #       # default.allowed-rates = []
  #       default.clock.rate = 192000;
  #       default.clock.quantum = 32;
  #       default.clock.min-quantum = 32;
  #       default.clock.max-quantum = 32;
  #     };
  #   };
  #   "pipewire/pipewire-pulse.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
  #     context.modules = [
  #       {
  #         name = "libpipewire-module-protocol-pulse";
  #         args = {
  #           pulse.min.req = "32/44100";
  #           pulse.default.req = "32/192000";
  #           pulse.max.req = "32/192000";
  #           pulse.min.quantum = "32/192000";
  #           pulse.max.quantum = "32/192000";
  #         };
  #       }
  #     ];
  #     stream.properties = {
  #       node.latency = "32/192000";
  #       resample.quality = 1;
  #     };
  #   };
  # };
  # services.pipewire.extraConfig = {};
}
