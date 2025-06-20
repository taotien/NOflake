{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nomachine-client
    delta
    mask
    mprocs
    presenterm
    # (llm.withPlugins (ps: with ps; [llm-openrouter]))
    # bash-language-server
    # digital
    # etcher
    # fontforge
    # freecad
    # llm
    # lychee # link checker
    # quickemu
    # radicle-node
    # vulkan-loader
    # act
    # aichat
    # aider-chat
    # asm-lsp
    b3sum
    devenv
    direnv
    gh
    # git-cliff
    hyperfine
    jujutsu
    just
    lldb
    # lua-language-server
    # markdown-oxide # markdown lsp
    qFlipper
    qemu
    sd
    sshfs
    taplo # toml lsp
    tio
    tokei # repo code stats
    typos

    # # databases
    # sqlite
    # sqls
    # sqlx-cli
    # sea-orm-cli
    # rainfrog

    # # arduino
    # arduino-language-server
    # arduino-cli
    # pkgsCross.avr.buildPackages.gcc
    # avrdude
    # ravedude

    # c
    clang
    clang-tools
    gcc
    gdb
    gnumake

    # nix
    nil
    alejandra

    # python
    # pypy3
    python3
    # (python3.withPackages (ps:
    #   with ps; [
    #     llm
    #     # llm-openrouter
    #   ]))
    # python310Packages.python-lsp-server
    uv
    ruff

    # rust
    cargo-binstall
    bacon
    cargo-expand
    cargo-feature
    cargo-generate
    cargo-watch
    elf2uf2-rs
    flip-link
    mdbook
    mold-wrapped
    probe-rs
    rustup
    rusty-man
    sccache
    trunk
    wasm-bindgen-cli
  ];

  hardware.flipperzero.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
  '';

  # virtualisation.docker = {
  #   enable = true;
  #   storageDriver = "btrfs";
  # };
  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };
  # users.extraGroups.docker.members = ["tao"];
}
