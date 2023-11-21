{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    python310Packages.python-lsp-server
    sqlite
    unstable.sqlx-cli
    unstable.ruff
    unstable.ruff-lsp
    pypy3
    python3
    # unstable.swagger-cli
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
    unstable.cargo
    unstable.cargo-edit
    unstable.cargo-feature
    unstable.cargo-rr
    unstable.clippy
    unstable.elf2uf2-rs
    unstable.pijul
    unstable.rust-analyzer
    unstable.rustc
    unstable.rustfmt
    unstable.sccache
    vulkan-loader
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
  '';
}
