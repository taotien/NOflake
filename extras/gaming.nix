{
  pkgs,
  lib,
  ...
}: let
  if_desktop =
    if lib.strings.hasPrefix "NOcomputer" (builtins.readFile /etc/hostname)
    then true
    else false;
in {
  # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
  # aagl.inputs.nixpkgs.follows = "nixpkgs";

  environment.systemPackages = with pkgs; [
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
  ];

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true;
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

  # THE FINALS audio borked
  services.pipewire.enable = !if_desktop;
  hardware.pulseaudio.enable = if_desktop;
  hardware.pulseaudio.support32Bit = if_desktop;
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
