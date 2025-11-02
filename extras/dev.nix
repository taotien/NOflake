{pkgs, ...}: {
    nix.settings.substituters = [
        "https://helix.cachix.org/"
        "https://devenv.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    services.lorri.enable = true;

    services.scx.enable = true;
    services.scx.scheduler = "scx_lavd"; # default is "scx_rustland"

    environment.systemPackages = with pkgs; [
        basedpyright
        mergiraf
        lazyjj
        egglog
        z3
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
        just-lsp
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
        ruff
        ty
        uv
        pyright

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
