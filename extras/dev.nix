{
    lib,
    pkgs,
    inputs,
    ...
}: let
    punstable = import inputs.nixpkgs-unstable {
        inherit (pkgs) system;
        config.allowUnfree = true;
    };
in {
    networking.firewall.allowedUDPPorts = [14550];
    # CycloneDDS/RTPS discovery+data for ROS_DOMAIN_ID=2 (voxel's shared default --
    # see ~/voxel/devenv.nix). Port = 7400 + 250*domainId + {0,1,10,11} + 2*participantIdx;
    # for domain 2 that's a base of 7900, and each additional DDS participant on this
    # host (a second ros2 node, mavros, etc.) claims 2 more ports up from there. This
    # range is generous rather than exact -- confirmed via `ss -uap` that a single
    # participant binds 7910/7911, but exactly how many participants run at once on a
    # dev box varies too much to pin down individually.
    # 17900-17999 is the same thing for ROS_DOMAIN_ID=42 (7400 + 250*42 = 17900) --
    # used to temporarily test on an unused domain, isolated from whatever else on
    # the fleet's network is sharing domain 2's port range and participant-index
    # pool. Add another {from=...; to=...;} entry here for any other domain ID
    # this laptop ends up testing against.
    networking.firewall.allowedUDPPortRanges = [
      { from = 7900; to = 7999; }
      { from = 17900; to = 17999; }
    ];

    services.dockerRegistry = {
        enable = true;
        listenAddress = "0.0.0.0";
        port = 5000;
        storagePath = "/var/lob/docker-registry";
        enableDelete = true;
        enableGarbageCollect = true;
        garbageCollectDates = "daily";
        openFirewall = false;
    };

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
    programs.vscode.enable = true;
    environment.systemPackages =
        (with punstable; [
            # keep-sorted start sticky_comments=no
            claude-code
            devenv
            rerun
            # keep-sorted end
        ])
        ++ (with pkgs; [
            nmap
            eternal-terminal
            foxglove-studio
            foxglove-cli
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

            # # alloy
            # bun
            # docker-compose
            # ngrok
            # deno

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
        ]);

    nix.settings.substituters = [
        "https://helix.cachix.org/"
        "https://devenv.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    services.lorri.enable = true;

    # scx_lavd repeatedly stalls the CPU for ~21s under gaming workloads,
    # triggering RCU-stall self-disable/re-enable cycles (kernel: "sched_ext:
    # lavd ... RCU CPU stall detected!"). Disabled until upstream is stable.
    services.scx.enable = false;
    # services.scx.scheduler = "scx_lavd"; # default is "scx_rustland"

    hardware.flipperzero.enable = true;

    services.udev.extraRules = ''
        SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
        SUBSYSTEM == "tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port",  SYMLINK+="ttyBmpTarg"

        # mobili
        KERNEL=="js[0-9]*", MODE="0666"

        # u-blox GNSS (F9P/F9R/M9N) - world rw so containerised ros node can open it
        SUBSYSTEM=="usb", ATTRS{idVendor}=="1546", ATTRS{idProduct}=="01a9", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
    '';

    boot.kernel.sysctl = {
        "net.core.rmem_max" = 67108864;
        "net.core.wmem_max" = 67108864;
        "net.core.rmem_max_default" = 67108864;
        "net.core.wmem_max_default" = 67108864;
    };

    # ROS2/CycloneDDS discovery is multicast-based, and this machine's Wi-Fi AP
    # does not reflect multicast back to the sender: pinning CycloneDDS to
    # wlan0 (which does report the MULTICAST interface flag) still failed to
    # discover a second process on the same host. lo is the only reliable path
    # for same-machine discovery here, but Linux does not mark it
    # multicast-capable by default, and CycloneDDS skips interfaces that
    # aren't. This flag does not persist across reboots on its own.
    systemd.services."cyclonedds-lo-multicast" = {
        description = "Enable multicast on lo for same-host ROS2/CycloneDDS discovery";
        wantedBy = ["multi-user.target"];
        after = ["network-pre.target"];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.iproute2}/bin/ip link set lo multicast on";
        };
    };

    # Default CycloneDDS onto loopback for interactive sessions, since wlan0
    # multicast is a dead end on this network. Project devenvs (e.g. voxel's)
    # can still override this per-shell if they ever need real cross-machine
    # discovery.
    environment.sessionVariables.CYCLONEDDS_URI = ''<CycloneDDS><Domain><General><Interfaces><NetworkInterface name="lo" priority="default" multicast="true"/></Interfaces><AllowMulticast>true</AllowMulticast></General></Domain></CycloneDDS>'';

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
