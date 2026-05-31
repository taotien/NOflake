{
    lib,
    pkgs,
    ...
}: {
    boot.kernel.sysctl."vm.overcommit_memory" = "1";

    # systemd.user.services.lspmux = {
    #     enable = true;
    #     wantedBy = ["default.target"];
    #     serviceConfig = {
    #         Type = "simple";
    #         ExecStart = "${pkgs.lspmux}/bin/lspmux server";
    #     };
    # };
    programs.qgroundcontrol.enable = true;
    environment.systemPackages = with pkgs; [
        foxglove-studio
        foxglove-cli
        claude-code
        # keep-sorted start sticky_comments=no
        # act
        # asm-lsp
        # bash-language-server
        # digital
        # egglog
        # etcher
        # fontforge
        # freecad
        # git-cliff
        # lazyjj
        # lua-language-server
        # lychee # link checker
        # markdown-oxide # markdown lsp
        # mask
        # mprocs
        # nomachine-client
        # presenterm
        # quickemu
        # radicle-node
        # vulkan-loader
        # z3
        b3sum
        basedpyright
        delta
        devenv
        direnv
        gh
        gpclient
        hyperfine
        jujutsu
        just
        just-lsp
        keep-sorted
        lldb
        lspmux
        maturin
        mergiraf
        mission-planner
        qFlipper
        qemu
        sd
        sshfs
        taplo # toml lsp
        tio
        tokei # repo code stats
        typos
        wild
        # keep-sorted end

        # alloy
        bun
        docker-compose
        ngrok
        deno

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

        # # cringelang
        # go
        # delve
        # gotools
        # gopls

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
        # keep-sorted start sticky_comments=no
        # leptosfmt
        # spacetimedb
        # wasm-bindgen-cli
        bacon
        cargo-autoinherit
        cargo-binstall
        cargo-edit
        cargo-expand
        cargo-feature
        cargo-generate
        cargo-nextest
        cargo-update
        cargo-watch
        dioxus-cli
        elf2uf2-rs
        flip-link
        mdbook
        mold
        probe-rs-tools
        rustup
        rusty-man
        sccache
        trunk
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

        # mobili
        KERNEL=="js[0-9]*", MODE="0666"
    '';

    boot.kernel.sysctl = {
        "net.core.rmem_max" = 67108864;
        "net.core.wmem_max" = 67108864;
        "net.core.rmem_max_default" = 67108864;
        "net.core.wmem_max_default" = 67108864;
    };

    hardware.nvidia-container-toolkit.enable =
        lib.strings.hasPrefix "NOcomputer" (builtins.readFile /etc/hostname);
    virtualisation.docker = {
        daemon.settings = {
            features = {
                buildkit = true;
                cdi = true;
            };
        };
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
