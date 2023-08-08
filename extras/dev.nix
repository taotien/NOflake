{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    elf2uf2-rs
    gcc
    gdb
    lldb
    rustup
    unstable.cargo-edit
    bacon
    cargo-feature
    # cmake
    # clang
    # pkg-config
    # udev
    # libclang
  ];

  # environment.variables = {
  #   LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.libclang.lib ];
  # };

  services.udev.extraRules = ''
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
  '';
}
