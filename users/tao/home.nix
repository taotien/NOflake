let
  enablePrograms = programs: builtins.mapAttrs (_: program: { enable = true; }) programs;
in
{
  imports = [
    ./helix.nix
  ];

  # programs = enablePrograms {
  programs = {
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

  home.username = "tao";
  home.homeDirectory = "/home/tao";
  home.stateVersion = "23.11";
}
