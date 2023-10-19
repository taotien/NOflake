{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    freecad
    # alsa-lib
    # alsa-oss
    clang
    # cmake
    # libclang
    # libopus
    # opencv
    # openssl
    # pkg-config
    # pkgconfig
    rustup
    # udev
    nixpkgs-fmt
    nil
    # expat
    # fontconfig
    # freetype
    # freetype.dev
    # libGL
    # pkgconfig
    # xorg.libX11
    # xorg.libXcursor
    # xorg.libXi
    # xorg.libXrandr
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
