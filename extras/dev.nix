{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # pijul
    # swagger-cli
    # swagger-codegen
    bacon
    cargo
    cargo-edit
    cargo-feature
    cargo-rr
    clang
    clang-tools
    clippy
    elf2uf2-rs
    etcher
    freecad
    gcc
    gdb
    gnumake
    gradle
    jdt-language-server
    jetbrains.idea-community
    jujutsu
    lldb
    mold-wrapped
    nil
    nixpkgs-fmt
    nodejs
    openapi-generator-cli
    pypy3
    python3
    python310Packages.python-lsp-server
    ruff
    ruff-lsp
    rust-analyzer
    rustc
    rustfmt
    rustup
    sccache
    sqlite
    sqlx-cli
    sshfs
    temurin-bin-17
    vscode-langservers-extracted
    vulkan-loader
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
