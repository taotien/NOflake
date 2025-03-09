{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  programs = {
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };

    bottom = {
      enable = true;
      settings = {
        color = "gruvbox";
        flags = {
          battery =
            # if lib.strings.hasPrefix "NOlaptop" (builtins.readFile /etc/hostname)
            # then true
            # else false;
            true;
          hide_time = true;
          enable_gpu = true;
        };
      };
    };

    nushell = {
      enable = true;
      configFile.source = ./nushell/config.nu;
      envFile.source = ./nushell/env.nu;
      # extraConfig = builtins.readFile ./nushell/stuff.nu;
      extraConfig = lib.concatStrings (map builtins.readFile (map (x: ./nushell/extras/. + x) (map (x: "/" + x) (builtins.attrNames (builtins.readDir ./nushell/extras)))));
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };

    zellij = {
      enable = true;
      settings = {};
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  # services.syncthing = {
  #   enable = true;
  #   # user = "tao";
  #   # dataDir = "/home/tao/sync";
  #   # configDir = "/home/tao/.config/syncthing";
  #   overrideDevices = true;
  #   overrideFolders = true;
  #   # openDefaultPorts = true;
  #   settings = {
  #     devices = {
  #       # we do a lil anti-patterns https://github.com/ryantm/agenix?tab=readme-ov-file#builtinsreadfile-anti-pattern
  #       # bootstrap by commenting out devices first and rebuild switch impurely
  #       "nocomputer".id = builtins.readFile config.age.secrets.syncthing-NOcomputer.path;
  #       "nolaptop".id = builtins.readFile config.age.secrets.syncthing-NOlaptop.path;
  #       "uwuraid".id = builtins.readFile config.age.secrets.syncthing-uwuraid.path;
  #     };
  #     folders = let
  #       devs = [
  #         "nocomputer"
  #         "nolaptop"
  #         "uwuraid"
  #       ];
  #     in {
  #       # "documents" = {
  #       #   path = "/home/tao/documents";
  #       #   devices = devs;
  #       # };
  #       "pictures" = {
  #         path = "/home/tao/pictures";
  #         devices = devs;
  #       };
  #       "projects" = {
  #         path = "/home/tao/projects";
  #         devices = devs;
  #       };
  #       "school" = {
  #         path = "/home/tao/school";
  #         devices = devs;
  #       };
  #       "sync" = {
  #         path = "/home/tao/sync";
  #         devices = devs;
  #       };
  #       # "work" = {
  #       #   path = "/home/tao/work";
  #       #   devices = devs;
  #       # };
  #     };
  #   };
  # };

  home.username = "vy";
  home.homeDirectory = "/home/vy";
  home.stateVersion = "23.11";
}
