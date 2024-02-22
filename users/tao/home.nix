{ pkgs, inputs, ... }: {
  imports = [
    (import ./helix.nix { inherit pkgs inputs; })
    # ./hyprland.nix
    ./cargo.nix
  ];

  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Tao Tien";
          email = "29749622+taotien@users.noreply.github.com";
        };
        ui =
          {
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
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
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
      settings = { };
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  home.username = "tao";
  home.homeDirectory = "/home/tao";
  home.stateVersion = "23.11";
}
