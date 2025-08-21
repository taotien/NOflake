{pkgs, ...}: {
    services.scx.enable = true;
    services.scx.scheduler = "scx_lavd"; # default is "scx_rustland"

    environment.systemPackages = with pkgs; [
        jupyter
        # cringelang
        go
        delve
        gotools
        gopls

        # act
        # asm-lsp
        # bash-language-server
        # digital
        # etcher
        # fontforge
        # freecad
        # git-cliff
        # lua-language-server
        # lychee # link checker
        # markdown-oxide # markdown lsp
        # quickemu
        # radicle-node
        # vulkan-loader
        b3sum
        delta
        devenv
        direnv
        gh
        hyperfine
        jujutsu
        just
        lldb
        mask
        mprocs
        nomachine-client
        presenterm
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

    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };
    # virtualisation.docker.rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
    users.extraGroups.docker.members = ["tao"];
}
