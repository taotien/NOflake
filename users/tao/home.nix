{ pkgs, inputs, ... }: {
  imports = [
    (import ./helix.nix { inherit pkgs inputs; })
    # ./hyprland.nix
  ];


  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Tao Tien";
          email = "29749622+taotien@users.noreply.github.com";
        };
      };
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

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  home.file.".cargo/config.toml".text = ''
    [build]
    target = "x86_64-unknown-linux-musl"
    
    [provile.dev]
    debug = 0
    strip = "debuginfo"

    [target.x86-unknown-linux-musl]
    linker = "clang"
    rustflag = ["-C", "link-arg=ld-path=${pkgs.mold}/bin/mold"]
  '';

  home.username = "tao";
  home.homeDirectory = "/home/tao";
  home.stateVersion = "23.11";
}
