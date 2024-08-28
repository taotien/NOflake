{
  pkgs,
  inputs,
  lib,
  ...
}: let
  cargoFile = builtins.readFile ./cargo.toml;
  cargoConfig = builtins.replaceStrings ["/path/to/sccache" "/path/to/mold"] ["${pkgs.sccache}/bin/sccache" "${pkgs.mold}/bin/mold}"] cargoFile;
in {
  imports = [
    ./boxxy.nix
    (import ./helix.nix {inherit pkgs inputs;})
    # ./plasma.nix
    # ./firefox.nix
  ];

  # home.sessionPath = [
  #   "/home/tao/.cargo/bin"
  # ];
  home.file.".cargo/config.toml".text = cargoConfig;
  home.file.".config/autostart" = {
    source = ./autostart;
    recursive = true;
  };
  home.file.".config/direnv/lib/uv.sh".source = ./uv.sh;

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
            if lib.strings.hasPrefix "NOlaptop" (builtins.readFile /etc/hostname)
            then true
            else false;
          hide_time = true;
          enable_gpu = true;
        };
      };
    };

    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
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

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      compression = true;
      matchBlocks = {
        "stargate" = {
          hostname = "stargate.cs.usfca.edu";
          user = "tltien";
          forwardAgent = true;
          identityFile = "/home/tao/.ssh/id_ed25519";
        };
        "beagle" = {
          hostname = "beagle";
          user = "tltien";
          forwardAgent = true;
          identityFile = "/home/tao/.ssh/id_ed25519";
          proxyCommand = "ssh stargate -W %h:%p";
        };
        "github" = {
          hostname = "github.com";
          forwardAgent = true;
          identityFile = "/home/tao/.ssh/id_ed25519";
        };
      };
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      dataLocation = "/home/tao/sync";
    };

    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };

    zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
      };
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

  services = {
    pueue = {
      enable = true;
      settings = {};
    };
  };

  xdg.userDirs = {
    desktop = "desktop";
    documents = "documents";
    download = "downloads";
    music = "music";
    pictures = "pictures";
    templates = "templates";
    videos = "videos";
    publicShare = null;
    createDirectories = true;
    enable = true;
  };

  home.username = "tao";
  home.homeDirectory = "/home/tao";
  home.stateVersion = "23.11";
}
