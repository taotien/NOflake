{
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    settings = {
      theme = "dracula";
      editor = {
        # rainbow-brackets = true;
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
          name = "arduino";
          scope = "source.arduino";
          injection-regex = "arduino";
          file-types = ["ino" "cpp" "h"];
          comment-token = "//";
          roots = ["*.ino" "sketch.yaml"];
          language-servers = ["arduino-language-server"];
          indent = {
            tab-width = 8;
            unit = "\t";
          };
          auto-format = true;
          formatter = {command = "clang-format";};
        }
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
        {
          name = "cpp";
          auto-format = true;
          formatter = {
            command = "clang-format";
            args = ["--style=file:/home/tao/Templates/clang-format"];
          };
          file-types = [
            "cc"
            "hh"
            "c++"
            "cpp"
            "hpp"
            "h"
            "ipp"
            "tpp"
            "cxx"
            "hxx"
            "ixx"
            "txx"
            "C"
            "H"
            "cu"
            "cuh"
            "cppm"
            "h++"
            "ii"
            "inl"
            {glob = ".hpp.in";}
            {glob = ".h.in";}
          ];
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
          text-width = 100;
        }
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
        arduino-language-server = {
          command = "arduino-language-server";
        };
      };
      grammar = [
        {
          name = "arduino";
          source = {
            git = "https://github.com/ObserverOfTime/tree-sitter-arduino";
            rev = "db929fc6822b9b9e1211678d508f187894ce0345";
          };
        }
      ];
    };
    enable = true;
    defaultEditor = true;
    # package = inputs.helix.packages.${pkgs.system}.default;
  };
}
