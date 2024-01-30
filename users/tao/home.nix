{
  imports = [
    ./helix.nix
  ];

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  programs.git = {
    enable = true;
    userName = "Tao Tien";
    userEmail = "29749622+taotien@users.noreply.github.com";
  };

  home.username = "tao";
  home.homeDirectory = "/home/tao";
  home.stateVersion = "23.11";
}
