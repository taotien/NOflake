{
  programs.helix = {
    settings = {
      theme = "dracula";
      editor = {
        line-number = "relative";
        cursorline = true;
        completion-replace = true;
        preview-completion-insert = false;
        indent-guides = {
          render = true;
          skip-levels = 2;
        };
        cursor-shape = {
          insert = "bar";
          select = "underline";
        };
        statusline = {
          left = [ "mode" "spinner" "spacer" "version-control" ];
          center = [ "file-name" "file-modification-indicator" ];
          right = [ "diagnostics" "primary-selection-length" "total-line-numbers" "selections" "position" ];
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        soft-wrap.enable = true;
      };
    };
    languages = {
      language = [
        {
          name = "c";
          auto-format = true;
          formatter = {
            command = "clang-format";
            args = [ "--style=file:/home/tao/Templates/clang-format" ];
          };
          indent = {
            tab-width = 8;
            unit = "\t";
          };
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixpkgs-fmt";
          };
        }
      ];
    };
    enable = true;
    defaultEditor = true;
  };
}
