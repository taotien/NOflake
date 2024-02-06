{ inputs, pkgs, ... }: {
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
          indent = { tab-width = 8; unit = "\t"; };
        }
        {
          name = "nix";
          auto-format = true;
          formatter = { command = "nixpkgs-fmt"; };
        }
        { name = "html"; auto-format = true; indent = { tab-width = 4; unit = "\t"; }; }
      ];
      grammar = [
        {
          name = "nix";
          source = {
            git = "https://github.com/nix-community/tree-sitter-nix";
            rev = "763168fa916a333a459434f1424b5d30645f015d";
          };
        }
      ];
    };
    enable = true;
    defaultEditor = true;
    package = inputs.helix.packages.${pkgs.system}.default;
  };
}
