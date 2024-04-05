{
  pkgs,
  inputs,
  lib,
  ...
}: let
  cargoFile = builtins.readFile ./cargo.toml;
  cargoConfig = builtins.replaceStrings ["path/to/sccache"] ["${pkgs.sccache}/bin/sccache"] cargoFile;
in {
  imports = [
    (import ./helix.nix {inherit pkgs inputs;})
    # ./plasma.nix
    # ./firefox.nix
  ];

  home.file.".cargo/config.toml".text = cargoConfig;
  home.file.".config/autostart" = {
    source = ./autostart;
    recursive = true;
  };

  programs = {
    bottom = {
      enable = true;
      settings = {
        battery =
          if lib.strings.hasPrefix "NOlaptop" (builtins.readFile /etc/hostname)
          then true
          else false;
        hide_time = true;
        enable_gpu = true;
      };
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Tao Tien";
          email = "29749622+taotien@users.noreply.github.com";
        };
        ui = {
          default-command = "log";
        };
      };
      # package = inputs.jujutsu.packages.${pkgs.system}.default;
    };

    git = {
      enable = true;
      userName = "Tao Tien";
      userEmail = "29749622+taotien@users.noreply.github.com";
      # extraConfig = {
      # };
    };

    nushell = {
      enable = true;
      configFile.source = ./nushell/config.nu;
      envFile.source = ./nushell/env.nu;
      extraConfig = builtins.readFile ./nushell/stuff.nu;
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    taskwarrior = {
      enable = true;
    };

    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };

    # zellij = {
    #   enable = true;
    #   settings = {};
    # };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  services = {
    pueue = {
      enable = true;
      settings = {};
    };
  };

  xdg.userDirs = {
    documents = "documents";
    download = "downloads";
    music = "music";
    pictures = "pictures";
    templates = "templates";
    videos = "videos";
    desktop = null;
    publicShare = null;
    createDirectories = true;
    enable = true;
  };

  home.username = "tao";
  home.homeDirectory = "/home/tao";
  home.stateVersion = "23.11";
}
