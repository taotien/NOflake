{ pkgs, ... }: {
  home.file.".cargo/config.toml".text = ''
    [alias]
    rr = "run --release"

    [build]
    target = "x86_64-unknown-linux-gnu"
    rustc-wrapper = "${pkgs.sccache}/bin/sccache"
    rustflags = ["-Z", "threads=8"]

    [unstable]
    codegen-backend = true

    [provile.dev]
    debug = 0
    strip = "debuginfo"
    opt-level = 1
    lto = "off"
    codegen-backend = "cranelift"

    [profile.dev.package."*"]
    # slow clean build for faster incrementals
    opt-level = 3

    [profile.release]
    incremental = true
    codegen-units = 1
    lto = "fat"

    # [target.x86-unknown-linux-musl]
    # # linker = "musl-gcc"
    # linker = "clang"
    # rustflag = ["-C", "target-cpu=native", "link-arg=ld-path=${pkgs.mold}/bin/mold"]
    
    [target.x86-unknown-linux-gnu]
    # linker = "musl-gcc"
    linker = "clang"
    rustflag = ["-C", "target-cpu=native", "link-arg=ld-path=${pkgs.mold}/bin/mold"]

    # https://benw.is/posts/how-i-improved-my-rust-compile-times-by-seventy-five-percent
    # jonhoo
  '';
}
