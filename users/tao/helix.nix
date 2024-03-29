{
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    settings = {
      theme = "dracula";
      editor = {
        rainbow-brackets = true;
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
          left = ["mode" "spinner" "spacer" "version-control"];
          center = ["file-name" "file-modification-indicator"];
          right = ["diagnostics" "primary-selection-length" "total-line-numbers" "selections" "position"];
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        soft-wrap.enable = true;
        smart-tab.supersede-menu = false;
      };
      keys.normal = {
        k = "move_line_down";
        j = "move_line_up";
      };
      keys.select = {
        k = "extend_line_down";
        j = "extend_line_up";
      };
    };
    languages = {
      language = [
        {
          name = "c";
          auto-format = true;
          formatter = {
            command = "clang-format";
            args = ["--style=file:/home/tao/Templates/clang-format"];
          };
          indent = {
            tab-width = 8;
            unit = "\t";
          };
        }
        # { name = "css"; comment = "/*"; }
        {
          name = "html";
          auto-format = false;
          indent = {
            tab-width = 4;
            unit = "\t";
          };
        }
        {
          name = "java";
          auto-format = true;
          indent = {
            tab-width = 4;
            unit = "\t";
          };
        }
        {
          name = "javascript";
          auto-format = true;
          indent = {
            tab-width = 4;
            unit = "\t";
          };
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {command = "alejandra";};
        }
        {
          name = "typst";
          indent = {
            tab-width = 4;
            unit = " ";
          };
        }
        # { name = "rust"; }
      ];
      language-servers = {
        rust-analyzer.config = {
          procMacro = {
            ignored = {
              leptos_macro = [
                # Optional:
                # "component",
                "server"
              ];
            };
          };
        };
      };
      language-server = {
        jdtls = {
          command = "jdtls";
          args = ["-data" "/home/tao/.cache/jdtls/workspace"];
        };
      };
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
