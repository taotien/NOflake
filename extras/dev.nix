{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # alsa-lib
    # alsa-oss
    # clang
    # cmake
    # libclang
    # libopus
    # opencv
    # openssl
    # pkg-config
    # pkgconfig
    # rustup
    # udev
    expat
    fontconfig
    freetype
    freetype.dev
    libGL
    pkgconfig
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
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

  environment.variables = {
    # LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.libclang.lib ];
    # LD_LIBRARY_PATH =
    #   builtins.foldl' (a: b: "${a}:${b}/lib") "${pkgs.vulkan-loader}/lib" pkgs;
    LD_LIBRARY_PATH = builtins.foldl' (a: b: "${a}:${b}/lib") "${pkgs.vulkan-loader}/lib" [
      pkgs.expat
      pkgs.fontconfig
      pkgs.freetype
      pkgs.freetype.dev
      pkgs.libGL
      pkgs.pkgconfig
      pkgs.xorg.libX11
      pkgs.xorg.libXcursor
      pkgs.xorg.libXi
      pkgs.xorg.libXrandr
      pkgs.vulkan-loader
    ];
  };

  services.udev.extraRules = ''
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
  '';
}
