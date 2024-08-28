{
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    settings = {
      theme = "gruvbox_dark_hard";
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
      keys.insert = {
        C-space = "completion";
        k = {k = "normal_mode";};
      };
      keys.normal = {
        k = "move_line_down";
        j = "move_line_up";
      };
      keys.select = {
        k = "extend_line_down";
        j = "extend_line_up";
      };
      keys.normal.space.w = {
        k = "jump_view_down";
        j = "jump_view_up";
        K = "swap_view_down";
        J = "swap_view_up";
      };
    };
    languages = {
      use-grammars.only = ["rust" "c" "cpp" "typst" "nix" "html" "toml" "markdown" "just" "bash"];
      language = [
        {
          name = "arduino";
          grammar = "arduino";
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
          formatter = {
            command = "clang-format";
            args = ["--style=file:/home/tao/templates/clang-format"];
          };
        }
        {
          name = "c";
          auto-format = true;
          formatter = {
            command = "clang-format";
            args = ["--style=file:/home/tao/templates/clang-format"];
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
            args = ["--style=file:/home/tao/templates/clang-format"];
          };
          indent = {
            tab-width = 8;
            unit = "\t";
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
        }
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
        {
          name = "toml";
          auto-format = true;
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
          command = "boxxy";
          args = ["arduino-language-server" "-cli" "arduino-cli" "-cli-config" "~/.local/share/arduino/cli/arduino-cli.yaml" "-jobs" "0"];
        };
      };
      grammar = [
        {
          name = "arduino";
          source = {
            git = "https://github.com/tree-sitter-grammars/tree-sitter-arduino";
            rev = "8518c3fa6b8562af545a496d55c9abd78f53e732";
          };
        }
      ];
    };
    enable = true;
    defaultEditor = true;
    # package = inputs.helix.packages.${pkgs.system}.default;
  };
}
