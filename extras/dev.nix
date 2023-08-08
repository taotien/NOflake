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
    # libclang
  ];

  # environment.variables = {
  #   LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.libclang.lib ];
  # };

}
