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
    direnv
    jujutsu
    just
    lldb
    lua-language-server
    qFlipper
    sd
    sqlite
    sqlx-cli
    sea-orm-cli
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

    # # java (DSA)
    gradle
    jdt-language-server
    jetbrains.idea-community
    maven
    temurin-bin-17

    # # michael (webdev)
    # nodejs
    # vscode-langservers-extracted
    # nodePackages_latest.typescript-language-server

    # nix
    nil
    # nixpkgs-fmt
    alejandra

    # # python
    # pypy3
    # python3
    # python310Packages.python-lsp-server
    # ruff
    # ruff-lsp

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

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   libxkbcommon
  #   libGL

  #   wayland.dev

  #   xorg.libX11
  #   xorg.libXrandr
  #   xorg.libXi
  #   xorg.libX11
  # ];

  services.udev.extraRules = ''
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
  '';
}
