# { pkgs, aagl, ... }: {
{ pkgs, ... }: {
  # imports = [ aagl.nixosModules.default ];

  environment.systemPackages = with pkgs; [
    heroic
    lutris
    mangohud
    prismlauncher
    wine
    # parsec-bin
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
    # "electron-12.2.3"
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # nix.settings = aagl.nixConfig;
  # programs.honkers-railway-launcher.enable = true;

  users = { groups.game = { }; };
  security.pam.loginLimits = [
    { domain = "@game"; type = "-"; item = "nice"; value = -20; }
  ];

  security.rtkit.enable = true;
  environment.etc =
    let
      json = pkgs.formats.json { };
    in
    {
      "pipewire/pipewire.conf.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
        context.properties = {
          # default.allowed-rates = []
          default.clock.rate = 48000;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
      "pipewire/pipewire-pulse.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "32/48000";
              pulse.max.req = "32/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "32/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
      # "pipewire/pipewire.d/99-input-denoising.conf" = json.generate "99-input-denoising.conf" {
      #   context.modules = [{
      #     name = "libpipewire-module-filter-chain";
      #   }];
      # };
    };
}
