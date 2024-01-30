{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "dracula";
      editor = {
        line-number = "relative";
        cursorline = true;
        completion-replace = true;
      };
    };
    languages = { };
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
