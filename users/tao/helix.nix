{
    inputs,
    pkgs,
    ...
}: {
    programs.helix = {
        settings = {
            # keep-sorted start block=yes
            editor = {
                # keep-sorted start block=yes
                auto-save = {
                    after-delay.enable = true;
                    after-delay.timeout = 1000;
                    focus-lost = true;
                };
                completion-replace = false;
                cursor-shape = {
                    insert = "bar";
                    select = "underline";
                };
                cursorline = true;
                end-of-line-diagnostics = "hint";
                indent-guides = {
                    render = true;
                    skip-levels = 2;
                };
                inline-diagnostics = {
                    cursor-line = "warning";
                };
                line-number = "relative";
                lsp = {
                    display-inlay-hints = true;
                    display-messages = true;
                    display-progress-messages = true;
                };
                preview-completion-insert = false;
                rainbow-brackets = true;
                shell = ["nu" "--stdin" "-c"];
                smart-tab.supersede-menu = false;
                soft-wrap.enable = true;
                statusline = {
                    left = ["mode" "spinner" "spacer" "version-control"];
                    center = ["file-name" "file-modification-indicator"];
                    right = ["diagnostics" "primary-selection-length" "total-line-numbers" "selections" "position"];
                };
                # keep-sorted end
            };
            keys = {
                # keep-sorted start block=yes
                insert = {
                    C-space = "completion";
                    k = {k = "normal_mode";};
                };
                normal = {
                    j = "move_line_up";
                    k = "move_line_down";
                };
                normal.space = {
                    l = "@:reload-all<ret>";
                    w = {
                        J = "swap_view_up";
                        K = "swap_view_down";
                        j = "jump_view_up";
                        k = "jump_view_down";
                    };
                    t = {
                        r = "@mip:reflow<ret>";
                        s = "@<A-s>:sort<ret>";
                    };
                };
                select = {
                    j = "extend_line_up";
                    k = "extend_line_down";
                };
                # keep-sorted end
            };
            theme = "gruvbox_dark_hard";
            # keep-sorted end
        };
        languages = {
            # keep-sorted start block=yes
            grammar = [
                {
                    name = "arduino";
                    source = {
                        git = "https://github.com/tree-sitter-grammars/tree-sitter-arduino";
                        rev = "8518c3fa6b8562af545a496d55c9abd78f53e732";
                    };
                }
            ];
            language = [
                # keep-sorted start block=yes
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
                    name = "go";
                    formatter.command = "goimports";
                }
                {
                    name = "html";
                    auto-format = false;
                    indent = {
                        tab-width = 4;
                        unit = "\t";
                    };
                }
                # {
                #   name = "java";
                #   auto-format = true;
                #   indent = {
                #     tab-width = 4;
                #     unit = "\t";
                #   };
                # }
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
                    formatter = {
                        # command = "alejandra";
                        # args = ["--experimental-config" "%{workspace_directory}/alejandra.toml"];
                        command = "nu";
                        args = ["--stdin" "-c" "alejandra --quiet --experimental-config '%{workspace_directory}/alejandra.toml' | keep-sorted -"];
                    };
                    language-servers = ["nil"];
                }
                {
                    name = "python";
                    auto-format = true;
                    language-servers = ["basedpyright" "ty" "ruff"];
                    # formatter = {
                    #     command = "ruff";
                    #     args = ["format"];
                    # };
                }
                {
                    name = "scheme";
                    language-servers = ["steel"];
                }
                {
                    name = "sql";
                    language-servers = ["sqls"];
                }
                {
                    name = "toml";
                    auto-format = true;
                }
                {
                    name = "typst";
                    language-servers = ["tinymist"];
                }
                {
                    name = "typst";
                    text-width = 100;
                }
                # keep-sorted end
            ];
            language-server = {
                basedpyright = {
                    command = "basedpyright-langserver";
                    args = ["--stdio"];
                };
                rust-analyzer.config.check.command = "clippy";
                # gas = {
                #   command = "asm-lsp";
                # };
                # jdtls = {
                #   command = "jdtls";
                #   args = ["-data" "/home/tao/.cache/jdtls/workspace"];
                # };
                arduino-language-server = {
                    command = "boxxy";
                    args = ["arduino-language-server" "-cli" "arduino-cli" "-cli-config" "~/.local/share/arduino/cli/arduino-cli.yaml" "-jobs" "0"];
                };
                # gopls = {
                #   config = {
                #     unusedVariable = false;
                #   };
                # };
                sqls = {
                    command = "sqls";
                };
                tinymist = {
                    command = "tinymist";
                    config = {
                        exportPdf = "onType";
                        outputPath = "$root/$dir/$name";
                    };
                };
                steel-language-server = {
                    command = "steel-language-server";
                };
            };
            language-servers = {
                rust-analyzer.config = {
                    server.path = "/home/tao/.cargo/bin/rust-analyzer";
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
            use-grammars.only = [
                # keep-sorted start
                "bash"
                "c"
                "cpp"
                "gas"
                "html"
                "just"
                "markdown"
                "nix"
                "rust"
                "scheme"
                "sql"
                "toml"
                "typst"
                # keep-sorted end
            ];
        };
        # keep-sorted end
        enable = true;
        defaultEditor = true;
        package = inputs.helix.packages.${pkgs.system}.default;
    };
}
