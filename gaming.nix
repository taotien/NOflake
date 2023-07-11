{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lutris
    mangohud
    prismlauncher
    wine
  ];

  programs.gamemode.enable = true;
  programs.steam.enable = true;

  security.rtkit.enable = true;
  environment.etc =
    let
      json = pkgs.formats.json { };
    in
    {
      "pipewire/pipewire.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
        context.properties = {
          # default.clock.rate = 48000;
          # default.allowed-rates = []
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
    };

}
