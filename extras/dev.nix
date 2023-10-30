{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnumake
    unstable.pijul
    freecad
    clang
    rustup
    nixpkgs-fmt
    nil
    bacon
    unstable.cargo
    unstable.cargo-feature
    unstable.cargo-rr
    clang-tools
    unstable.clippy
    unstable.elf2uf2-rs
    etcher
    gcc
    gdb
    lldb
    unstable.rust-analyzer
    unstable.rustfmt
    unstable.cargo-edit
    unstable.rustc
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
