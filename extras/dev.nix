{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    elf2uf2-rs
    gcc
    gdb
    lldb
    rustup
  ];
}
