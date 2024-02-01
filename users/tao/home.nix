{
  imports = [
    ./helix.nix
  ];

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };

  programs.git = {
    enable = true;
    userName = "Tao Tien";
    userEmail = "29749622+taotien@users.noreply.github.com";
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      nix_shell = {
        disabled = false;
        impure_msg = ";[impure shell](bold red)";
        pure_msg = ";[pure shell](bold green)";
        unknown_msg = ";[unknown shell](bold yellow)";
        format = "via [☃️ $state( \($name\))](bold blue)";
      };
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  home.username = "tao";
  home.homeDirectory = "/home/tao";
  home.stateVersion = "23.11";
}
