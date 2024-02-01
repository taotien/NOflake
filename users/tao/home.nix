let
  enablePrograms = programs: builtins.mapAttrs (_: program: { enable = true; }) programs;
in
{
  imports = [
    ./helix.nix
  ];

  programs = enablePrograms {
    git = {
      userName = "Tao Tien";
      userEmail = "29749622+taotien@users.noreply.github.com";
    };

    nushell = {
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
    };

    starshell = {
      enableNuShellIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.nix);
    };

    wezterm = {
      extraConfig = builtins.readFile ./wezterm.lua;
    };

    zoxide = {
      enableNushellIntegration = true;
    };
  };

  home.username = "tao";
  home.homeDirectory = "/home/tao";
  home.stateVersion = "23.11";
}
