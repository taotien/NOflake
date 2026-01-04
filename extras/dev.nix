{
    lib,
    pkgs,
    ...
}: {
    programs.qgroundcontrol.enable = true;
    environment.systemPackages = with pkgs; [
        maturin
        mission-planner
        # keep-sorted start
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
        basedpyright
        delta
        devenv
        direnv
        egglog
        flip-link
        gh
        gpclient
        hyperfine
        jujutsu
        just
        just-lsp
        keep-sorted
        lazyjj
        lldb
        mask
        mergiraf
        mprocs
        # nomachine-client
        presenterm
        qFlipper
        qemu
        sd
        sshfs
        taplo # toml lsp
        tio
        tokei # repo code stats
        typos
        wild
        z3
        # keep-sorted end

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

        # cringelang
        go
        delve
        gotools
        gopls

        # nix
        nil
        alejandra

        # python
        # pypy3
        pyright
        python3
        ruff
        ty
        uv

        # rust
        # leptosfmt
        # keep-sorted start
        bacon
        dioxus-cli
        cargo-autoinherit
        cargo-binstall
        cargo-edit
        cargo-expand
        cargo-feature
        cargo-generate
        cargo-update
        cargo-watch
        elf2uf2-rs
        flip-link
        mdbook
        mold
        probe-rs-tools
        rustup
        rusty-man
        sccache
        trunk
        wasm-bindgen-cli
        # keep-sorted end
    ];

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

    hardware.flipperzero.enable = true;

    services.udev.extraRules = ''
        SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
        SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"
    '';

    virtualisation.docker = {
        enable = true;
        # storageDriver =
        #     if lib.strings.hasPrefix "NOlaptop" (builtins.readFile /etc/hostname)
        #     then "bcachefs"
        #     else "btrfs";
        storageDriver =
            if lib.strings.hasPrefix "NOcomputer" (builtins.readFile /etc/hostname)
            then "btrfs"
            else null;
    };
    # virtualisation.docker.rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
    users.extraGroups.docker.members = ["tao"];
}
