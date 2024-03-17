{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    (import ./helix.nix {inherit pkgs inputs;})
  ];

  home.file.".cargo/config.toml".text = builtins.readFile ./cargo.toml;

  programs = {
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
      package = inputs.jujutsu.packages.${pkgs.system}.default;
    };

    git = {
      enable = true;
      userName = "Tao Tien";
      userEmail = "29749622+taotien@users.noreply.github.com";
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

  home.username = "tao";
  home.homeDirectory = "/home/tao";
  home.stateVersion = "23.11";
}
