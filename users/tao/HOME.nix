{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cargoFile = builtins.readFile ./cargo.toml;
  cargoConfig = builtins.replaceStrings ["/path/to/sccache" "/path/to/mold"] ["${pkgs.sccache}/bin/sccache" "${pkgs.mold}/bin/mold}"] cargoFile;
  age.secrets.syncthing-NOcomputer.file = ../secrets/syncthing-NOcomputer.age;
  age.secrets.syncthing-NOlaptop.file = ../secrets/syncthing-NOlaptop.age;
  age.secrets.syncthing-uwuraid.file = ../secrets/syncthing-uwuraid.age;
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
  home.file.".config/direnv/lib/".source = ./direnv;
  home.file.".config/direnv/lib/".recursive = true;

  programs = {
    bacon = {
      enable = true;
      settings.jobs.default = {
        command = [
          "cargo"
          "clippy"
          "--"
          "-A"
          "clippy::bool_to_int_with_if"
          "-A"
          "clippy::collapsible_else_if"
          "-A"
          "clippy::collapsible_if"
          "-A"
          "clippy::derive_partial_eq_without_eq"
          "-A"
          "clippy::get_first"
          "-A"
          "clippy::if_same_then_else"
          "-A"
          "clippy::len_without_is_empty"
          "-A"
          "clippy::map_entry"
          "-A"
          "clippy::while_let_on_iterator"
        ];
        need_stdout = false;
      };
    };

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
      ignores = [
        "/target"
        ".direnv"
      ];
    };

    nushell = {
      enable = true;
      configFile.source = ./nushell/config.nu;
      envFile.source = ./nushell/env.nu;
      # extraConfig = builtins.readFile ./nushell/stuff.nu;
      extraConfig = lib.concatStrings (map builtins.readFile (map (x: ./nushell/extras/. + x) (map (x: "/" + x) (builtins.attrNames (builtins.readDir ./nushell/extras)))));
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
        "griffin" = {
          hostname = "griffin";
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

  services.syncthing = {
    enable = true;
    # user = "tao";
    # dataDir = "/home/tao/sync";
    # configDir = "/home/tao/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    # openDefaultPorts = true;
    settings = {
      devices = {
        # we do a lil anti-patterns https://github.com/ryantm/agenix?tab=readme-ov-file#builtinsreadfile-anti-pattern
        # bootstrap by commenting out devices first and rebuild switch impurely
        "nocomputer".id = builtins.readFile config.age.secrets.syncthing-NOcomputer.path;
        "nolaptop".id = builtins.readFile config.age.secrets.syncthing-NOlaptop.path;
        "uwuraid".id = builtins.readFile config.age.secrets.syncthing-uwuraid.path;
      };
      folders = let
        devs = [
          "nocomputer"
          "nolaptop"
          "uwuraid"
        ];
      in {
        # "documents" = {
        #   path = "/home/tao/documents";
        #   devices = devs;
        # };
        "pictures" = {
          path = "/home/tao/pictures";
          devices = devs;
        };
        "projects" = {
          path = "/home/tao/projects";
          devices = devs;
        };
        "school" = {
          path = "/home/tao/school";
          devices = devs;
        };
        "sync" = {
          path = "/home/tao/sync";
          devices = devs;
        };
        # "work" = {
        #   path = "/home/tao/work";
        #   devices = devs;
        # };
      };
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
