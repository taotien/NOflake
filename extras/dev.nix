{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # pijul
    # vulkan-loader
    etcher
    # freecad
    hyperfine
    jq
    inputs.helix.packages.${pkgs.system}.default
    just
    lldb
    sqlite
    sqlx-cli
    sshfs

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

    # michael
    nodejs
    vscode-langservers-extracted

    # nix
    nil
    nixpkgs-fmt

    # python
    pypy3
    # python3
    python310Packages.python-lsp-server
    ruff
    ruff-lsp

    #rust
    bacon
    elf2uf2-rs
    mdbook
    mold-wrapped
    rustup
    sccache
    trunk
  ];

  nixpkgs.config.permittedInsecurePackages = [
    # probably etcher
    "electron-19.1.9"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
  '';
}
