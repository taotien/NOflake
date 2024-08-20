{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # lychee # link checker
    # etcher
    # freecad
    # gh
    # vulkan-loader
    # fontforge
    # radicle-node
    # hyperfine # benchmarking
    markdown-oxide
    git-cliff
    b3sum
    direnv
    jujutsu
    just
    lldb
    lua-language-server
    qFlipper
    sd
    # sqlite
    # sqlx-cli
    # sea-orm-cli
    sshfs
    taplo # toml lsp
    tio
    tokei
    typos

    # # arduino
    # arduino-language-server
    # arduino-cli
    # pkgsCross.avr.buildPackages.gcc
    # avrdude
    # ravedude

    # c
    clang
    clang-tools
    gcc
    gdb
    gnumake

    # nix
    nil
    alejandra

    # # python
    # pypy3
    # python3
    # python310Packages.python-lsp-server
    # ruff
    # ruff-lsp

    # go
    go
    gopls
    delve

    #rust
    bacon
    cargo-feature
    cargo-generate
    cargo-watch
    elf2uf2-rs
    flip-link
    mdbook
    mold-wrapped
    probe-rs
    rustup
    sccache
    trunk
    wasm-bindgen-cli
  ];

  hardware.flipperzero.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
  '';
}
