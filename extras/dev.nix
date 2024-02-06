{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mold-wrapped
    jetbrains.idea-community
    jdt-language-server
    gradle
    temurin-bin-17
    nodejs
    python310Packages.python-lsp-server
    sqlite
    sqlx-cli
    ruff
    ruff-lsp
    pypy3
    python3
    # swagger-cli
    # swagger-codegen
    sshfs
    openapi-generator-cli
    bacon
    clang
    clang-tools
    etcher
    freecad
    gcc
    gdb
    gnumake
    lldb
    nil
    nixpkgs-fmt
    rustup
    cargo
    cargo-edit
    cargo-feature
    cargo-rr
    clippy
    elf2uf2-rs
    pijul
    rust-analyzer
    rustc
    rustfmt
    sccache
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
