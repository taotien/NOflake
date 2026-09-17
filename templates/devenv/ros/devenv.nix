{
    pkgs,
    lib,
    config,
    inputs,
    nix-ros-overlay,
    ...
}: let
    vendor = import ./vendor;

    # Shared by enterShell and the ros2ws:build task: nixpkgs' ccWrapper_addCVars
    # setup hook fires multiple times per package (envHostHostHook +
    # envHostTargetHook), so NIX_CFLAGS_COMPILE/NIX_LDFLAGS end up with every
    # -isystem/-fmacro-prefix-map/-L entry duplicated 4-6x by the time the shell
    # environment is assembled. That's a known, still-open nixpkgs bug
    # (NixOS/nixpkgs#41340; NixOS/nix#5593) that hits nix-ros-overlay especially
    # hard because ROS workspaces pull in dozens of packages -- see the
    # nix-ros-overlay-specific report at
    # https://discourse.nixos.org/t/argument-list-too-long-due-to-inflated-nix-cflags-compile/77367.
    # Once the *duplicated* content pushes a single variable over Linux's fixed
    # 128KB MAX_ARG_STRLEN cap, execve() fails for any subprocess that inherits
    # it -- this is NOT the same limit as `ulimit -s` controls (that's ARG_MAX,
    # the combined argv+envp budget; MAX_ARG_STRLEN is a separate, unconditional
    # per-string kernel constant -- raising ulimit -s does nothing here). No
    # official fix exists upstream; deduplicate instead. This has to run as a
    # shell script against the environment the shell hook actually assembled --
    # a static `env` value can't do it, since the bloat is produced by Nix's
    # setup hooks at shell-hook time, not at config-eval time.
    #
    # Run this from BOTH enterShell and any task that invokes a compiler
    # (colcon build, cargo build/check, an editor-launched rust-analyzer, ...):
    # anything that inherits the shell's own (still-bloated)
    # NIX_CFLAGS_COMPILE/NIX_LDFLAGS directly hits an identical `mktemp:
    # Argument list too long` the moment it invokes the wrapped clang/gcc.
    dedupeFlagsShellFunction = ''
                dedupe_flags() {
                    local var="$1"
                    local val="''${!var}"
                    [ -n "$val" ] || return 0
                    export "$var"="$(python3 -c '
        import sys, shlex
        tokens = shlex.split(sys.argv[1])
        pair_flags = {"-isystem", "-idirafter", "-iquote", "-I", "-L", "-rpath"}
        seen = set()
        out = []
        i = 0
        while i < len(tokens):
            t = tokens[i]
            if t in pair_flags and i + 1 < len(tokens):
                pair = (t, tokens[i + 1])
                if pair not in seen:
                    seen.add(pair)
                    out += [t, tokens[i + 1]]
                i += 2
            else:
                if t not in seen:
                    seen.add(t)
                    out.append(t)
                i += 1
        print(" ".join(shlex.quote(x) for x in out))
        ' "$val")"
                }
                dedupe_flags NIX_CFLAGS_COMPILE
                dedupe_flags NIX_CFLAGS_COMPILE_FOR_BUILD
                dedupe_flags NIX_LDFLAGS
                dedupe_flags NIX_LDFLAGS_FOR_BUILD
    '';
in {
    # TEMPLATE: rename per project.
    name = "CHANGEME";

    # https://devenv.sh/packages/
    packages = with pkgs;
        [
            git
            jujutsu # optional -- drop if you use plain git

            colcon
            cmake # required by ament_cmake packages; >=3.21 needed if you add r2r's
            # colcon integration (r2r_cargo.cmake) -- nixpkgs is well past that anyway
            sccache

            # Only needed if you're using r2r (or anything else that runs bindgen
            # directly against libclang, bypassing the compiler wrapper -- see
            # BINDGEN_EXTRA_CLANG_ARGS below). Drop otherwise.
            llvmPackages.libclang

            # --- carried over from voxel -- trim/replace for your own project ---
            doxygen # optional CMake docs target support
            gst_all_1.gstreamer # GStreamer-based camera/RTSP pipelines (gstreamer-rs etc.)
            gst_all_1.gst-plugins-base # rtspsrc/decodebin/videoconvert, GstApp for appsink
            rerun # standalone Rerun viewer (not the ROS2 bridge -- see ros-env comment below)
        ]
        ++ (with pkgs.rosPackages.humble; [
            # TEMPLATE: swap `humble` above for your ROS2 distro (iron, jazzy,
            # rolling, ...) if needed -- check nix-ros-overlay's README for which
            # distros it currently packages.
            (buildEnv {
                name = "ros-env";
                paths = [
                    # Minimal starter set. nix-ros-overlay package names are the
                    # upstream ROS package name with underscores swapped for
                    # hyphens (ament_cmake_core -> ament-cmake-core). Tab-complete
                    # `pkgs.rosPackages.humble.<TAB>` in `nix repl` to find more, or
                    # grep nix-ros-overlay's own generated package set.
                    ros-core
                    ament-cmake-core

                    tf2-ros
                    tf2-tools
                    tf2-geometry-msgs
                    tf2-sensor-msgs

                    # ADD YOUR WORKSPACE'S ROS PACKAGE DEPENDENCIES HERE.
                    # Group them by which of your own packages need them, with a
                    # comment naming that package -- it makes trimming or auditing
                    # this list later far easier than an alphabetical dump.

                    # --- carried over from voxel -- trim/replace for your own
                    # project. Kept as a worked example: these are the
                    # nix-ros-overlay names for a real fleet's mavros/camera/
                    # perception/GPS stack, grouped by which of that project's
                    # own packages needed them. ---

                    rcl-action # r2r_cargo() dependency for ROS2 action support
                    example-interfaces
                    python-cmake-module # rosidl_generate_interfaces (rosidl_generator_py) needs this

                    # camera driver / mavros feedback nodes
                    mavros
                    mavros-extras
                    cv-bridge
                    image-common
                    image-transport
                    image-transport-plugins
                    compressed-image-transport
                    camera-info-manager
                    usb-cam
                    v4l2-camera
                    lifecycle-msgs

                    # point cloud / voxel mapping
                    pcl-conversions
                    pcl-msgs
                    pcl-ros
                    octomap-msgs

                    # GPS/geo (autonomy, mission supervisor, battery monitor)
                    geographic-msgs
                    nmea-msgs
                    ntrip-client
                    rtcm-msgs
                    robot-localization

                    # perception (feature tracking, detection)
                    vision-msgs

                    # bag recording/playback
                    rosbag2
                    rosbag2-cpp
                    rosbag2-storage

                    # cross-cutting: lifecycle nodes, diagnostics, rosbridge
                    diagnostic-updater
                    realtime-tools
                    pluginlib
                    rosbridge-suite

                    # visualization/debugging
                    foxglove-bridge
                    # plotjuggler-ros # pulls in plotjuggler (Qt5) -- can collide with a
                    # Qt6-enabled vtk if you ever override vtk in vendor/default.nix for
                    # PCL visualization support. Re-enable and sort out the Qt version
                    # pinning if you actually need it.
                    # NOT rerun_ros (the actual ROS2<->Rerun bridge): as of writing its
                    # package.xml declares ament_cargo and depends on rclrs from a
                    # *fork* (esteve/ros2_rust, branch generic-subscriptions -- not
                    # mainline) -- nix-ros-overlay's buildRosPackage has no built-in
                    # ament_cargo support, and this compounds that gap with an
                    # experimental fork dependency. The standalone rerun viewer above
                    # has none of that baggage -- add the bridge separately,
                    # deliberately, once/if you actually need it.

                    rmw-cyclonedds-cpp
                ];
            })
        ]);

    overlays = [
        nix-ros-overlay.overlays.default
        vendor
    ];
    cachix.pull = ["ros"]; # avoids rebuilding nix-ros-overlay's packages from source

    # TEMPLATE: drop this whole `languages.rust` block if you're not writing any
    # Rust ROS nodes.
    #
    # Nightly is required by the compile-time tuning below (Cranelift dev codegen
    # backend, `-Z threads`) -- unrelated to which ROS Rust binding you use, if
    # any. Pinned by date (not floating) for reproducibility -- bump deliberately.
    languages.rust = {
        enable = true;
        channel = "nightly";
        version = "2026-08-01";
        components = ["rustc" "cargo" "clippy" "rustfmt" "rust-analyzer" "rust-src"];
        rustflags = "-Z threads=8";
        wild.enable = true;
        cranelift = {
            enable = true;
            # If you're using r2r: its build.rs does real codegen (bindgen), so
            # keep build scripts/proc macros on the well-tested LLVM backend and
            # reserve cranelift for your own app's dev-build iteration loop.
            forceBuildScriptsLlvm = true;
        };
    };

    # TEMPLATE: drop this whole `languages.python` block if you're not writing
    # any Python ROS nodes (or add it back per-language as needed).
    languages.python = {
        enable = true;
        # Pinned to the same pythonXXX that nix-ros-overlay builds rclpy against
        # for your chosen ROS distro (both flow from the same pinned nixpkgs --
        # see devenv.yaml's `nixpkgs: follows:`), so this interpreter and the ROS
        # env's compiled extensions (rclpy) share one ABI. Check nix-ros-overlay's
        # flake.nix / rosPackages.<distro>.rclpy for which python3XX it pins, and
        # match it here.
        package = pkgs.python313.withPackages (ps:
            with ps; [
                # --- carried over from voxel -- trim/replace for your own project.
                # opencv4/piexif are real nixpkgs packages (properly rpath-patched,
                # unlike PyPI's manylinux wheels), so they're built into the
                # interpreter directly rather than pulled via uv. ---
                opencv4
                piexif
                pymavlink
                autobahn
                twisted
                txaio
                fastcrc
                # roslibpy and rerun-sdk aren't usable straight from nixpkgs here
                # (roslibpy isn't packaged at all; nixpkgs' rerun-sdk attribute
                # evaluates but produces no importable `rerun` module) -- add
                # those to pyproject.toml for uv instead, if you need them.
            ]);
        uv = {
            enable = true;
            # Without this, uv installs into .devenv/state/venv but nothing
            # points PATH/VIRTUAL_ENV at it -- plain `python3` silently sees only
            # the Nix-managed packages above, not anything from pyproject.toml,
            # and you have to remember `uv run` instead. This runs `uv sync` on
            # shell entry and exports PATH/VIRTUAL_ENV for that venv, so plain
            # `python3` sees both. Requires a pyproject.toml (even an empty
            # `[project]` one) at the repo root.
            sync.enable = true;
        };
    };

    env = {
        # --- Rust/bindgen (r2r etc.) -- drop this section if not using Rust ---
        LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
        RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
        SCCACHE_DIR = "${config.devenv.state}/sccache";

        # bindgen (used by r2r_rcl/r2r_actions and similar FFI-generating crates)
        # calls libclang directly rather than through the compiler-wrapper
        # scripts that normally inject Nix's include paths -- a known
        # NixOS/bindgen gotcha: clang-sys bypasses the wrapper entirely. Without
        # this, bindgen can't even find <stdio.h>/<stdlib.h>. Clang's own
        # resource-dir (builtin headers like <stddef.h>) plus glibc's dev headers
        # is enough to parse typical ROS C headers.
        BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${pkgs.clang}/resource-root/include -isystem ${pkgs.glibc.dev}/include";

        # languages.rust's clangLinker (default true on Linux, for Cargo's own
        # linker driver) leaves bare `clang`/`clang++` resolving on PATH to the
        # *unwrapped* llvmPackages compiler -- fine for Cargo (it only reads
        # CARGO_TARGET_*_LINKER), but CMake picks up CC/CXX for its own compiler
        # detection, and the unwrapped clang has no glibc sysroot/crt/libgcc
        # wiring: `cannot find Scrt1.o`/`crti.o`/`-lgcc`, failing to compile even
        # a trivial test program the moment any ament_cmake package exists in
        # your workspace. Pin to the properly wrapped gcc instead.
        CC = "${pkgs.gcc}/bin/gcc";
        CXX = "${pkgs.gcc}/bin/g++";

        # KNOWN BROKEN as of 2026-09: confirmed by direct check (`devenv shell --
        # bash -lc 'echo $CC'`, with and without --no-eval-cache) that a plain
        # `devenv shell` still resolves CC/CXX to bare clang/clang++ despite this
        # assignment -- something in languages.rust's own env contribution
        # (clangLinker, most likely) wins over this one, probably a
        # module-priority thing (mkForce or similar) rather than plain attrset
        # overwrite, since this literally is the later assignment in file order.
        # The `ros2ws:build` task below works around it by re-exporting CC/CXX
        # itself -- but that means every *other* entry point that does a fresh
        # CMake configure (a bare `colcon build` typed directly into an
        # interactive shell, in particular) still hits the original
        # Scrt1.o/-lgcc failure this comment describes. Not root-caused or fixed
        # yet; re-export CC/CXX by hand before a fresh `colcon build
        # --packages-select <pkg>` if you hit this outside the task.

        # --- ROS runtime config -- carried over from voxel, adjust to your own
        # project/fleet. NOT porting CYCLONEDDS_URI -> a cyclonedds.xml here:
        # that file would pin NetworkInterfaceAddress to a specific robot's NIC
        # name, breaking discovery on a workstation without one. Set
        # CYCLONEDDS_URI yourself if you need it. ---
        RMW_IMPLEMENTATION = "rmw_cyclonedds_cpp";
        ROS_DOMAIN_ID = "2";
    };

    tasks = {
        "ros2ws:build" = {
            exec = ''
                cd "${config.devenv.root}/ros2_ws"

                # Match the CC/CXX the `env` block above sets (see that comment
                # for the full story): bare CC=clang/CXX=clang++ resolves to the
                # unwrapped llvmPackages compiler (no glibc sysroot/crt/libgcc
                # wiring), so ament_cmake's compiler-detection try_compile fails
                # with "cannot find Scrt1.o"/"-lgcc" etc. `pkgs.gcc` is the one
                # confirmed to work as a fully-qualified path (a bare `clang` or
                # even `''${pkgs.clang}/bin/clang` both still hit the same
                # missing-crt failure in this nixpkgs pin).
                export CC="${pkgs.gcc}/bin/gcc"
                export CXX="${pkgs.gcc}/bin/g++"

                # enterShell already runs this for interactive sessions, but a
                # `devenv tasks run` invocation isn't guaranteed to go through
                # enterShell first -- cheap and idempotent, so just rerun it
                # rather than rely on that ordering. See dedupeFlagsShellFunction's
                # definition near the top of this file for why it's needed at all.
                ${dedupeFlagsShellFunction}

                colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

                # clangd (see .helix/languages.toml) finds compile_commands.json by
                # walking up from the source file being edited, but colcon writes
                # it under build/<pkg>/, not next to the sources in src/<pkg>/ --
                # and packages aren't necessarily one level deep. Symlink using
                # colcon's own name -> source-path mapping so this stays correct
                # regardless of nesting. No-op for ament_python packages, which
                # never produce one.
                while IFS="$(printf '\t')" read -r pkg_name pkg_path _; do
                    db="build/$pkg_name/compile_commands.json"
                    [ -e "$db" ] || continue
                    ln -sf "$(realpath --relative-to="$pkg_path" "$db")" "$pkg_path/compile_commands.json"
                done < <(colcon list)

                # See the comment on `status` below for why this exists instead of
                # comparing against install/ itself.
                touch .devenv-last-build
            '';
            # Deliberately NOT `before = ["devenv:enterShell"]`: that makes shell
            # entry itself fail whenever any package in the workspace fails to
            # build, which turns "one package doesn't compile yet" into "nobody
            # can get a shell." Run explicitly via `devenv tasks run
            # ros2ws:build`, or just `colcon build` in ros2_ws.
            #
            # Skip the build if nothing colcon actually acts on is newer than the
            # last build. colcon itself is incremental too, so this is just to
            # avoid paying its startup/scan overhead on every shell entry.
            #
            # Two things this deliberately avoids:
            #
            # 1. Comparing against install/ itself (an earlier version of this
            #    check): colcon only bumps a directory's own mtime when it adds or
            #    removes an immediate child, not when it rewrites files nested
            #    inside an already-existing package dir. Once every package has
            #    been installed once, install/'s top-level mtime freezes forever,
            #    so a real incremental rebuild would never register as "done" and
            #    this would run on every single shell entry. Comparing against a
            #    stamp file this task touches itself after a successful build
            #    sidesteps that entirely.
            # 2. Matching "any file under src" -- that re-triggers a full colcon
            #    build the moment you touch a README, a .gitignore, or any other
            #    file colcon never looks at, which in practice during active
            #    development is most of the time. This is deliberately an
            #    allowlist instead; extend it as new build-relevant file types
            #    show up (this already covers an r2r crate's Cargo.toml/*.rs/
            #    dummy.c).
            status = ''
                cd "${config.devenv.root}/ros2_ws"
                [ -f .devenv-last-build ] || exit 1
                [ -z "$(find src \( \
                    -name '*.py' -o \
                    -name 'package.xml' -o \
                    -name 'setup.py' -o \
                    -name 'setup.cfg' -o \
                    -name 'CMakeLists.txt' -o \
                    -name '*.msg' -o -name '*.srv' -o -name '*.action' -o \
                    -name 'Cargo.toml' -o -name '*.rs' -o -name 'dummy.c' \
                \) -newer .devenv-last-build -print -quit)" ]
            '';
        };
    };

    enterShell = ''
        ros2ws_setup="${config.devenv.root}/ros2_ws/install/setup.sh"
        if [ -f "$ros2ws_setup" ]; then
            source "$ros2ws_setup"
        else
            echo "ros2_ws/install/setup.sh not found yet -- run 'colcon build' in ros2_ws/" >&2
        fi

        # See dedupeFlagsShellFunction's definition near the top of this file:
        # without this, a bare `cargo check`/rust-analyzer (or anything else
        # started from this shell that links via the wrapped clang) hits
        # `mktemp: Argument list too long` the moment a build script needs
        # linking, from the same NIX_CFLAGS_COMPILE/NIX_LDFLAGS duplication bug
        # that ros2ws:build's own exec script already works around.
        ${dedupeFlagsShellFunction}
    '';
}
