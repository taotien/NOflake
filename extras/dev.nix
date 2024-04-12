{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # etcher
    # freecad
    # gh
    # vulkan-loader
    hyperfine
    jq
    jujutsu
    just
    lldb
    lua-language-server
    radicle-cli
    sd
    sqlite
    sqlx-cli
    sshfs
    taplo
    tio
    tokei

    # arduino
    arduino-language-server
    arduino-cli
    pkgsCross.avr.buildPackages.gcc
    avrdude
    ravedude

    # c
    clang
    clang-tools
    gcc
    gdb
    gnumake

    # java (DSA)
    gradle
    jdt-language-server
    jetbrains.idea-community
    temurin-bin-17

    # michael (webdev)
    nodejs
    vscode-langservers-extracted
    nodePackages_latest.typescript-language-server

    # nix
    nil
    # nixpkgs-fmt
    alejandra

    # python
    # pypy3
    # python3
    # python310Packages.python-lsp-server
    # ruff
    # ruff-lsp

    #rust
    bacon
    cargo-feature
    cargo-generate
    bacon
    elf2uf2-rs
    mdbook
    mold-wrapped
    rustup
    sccache
    trunk
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libxkbcommon
    libGL

    wayland.dev

    xorg.libX11
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
  ];

  services.udev.extraRules = ''
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
  '';
}
