# devenv-ros

A [devenv.sh](https://devenv.sh) template for ROS2 development on Nix, using
[nix-ros-overlay](https://github.com/lopsided98/nix-ros-overlay) instead of
Docker. Optionally wires up Rust (nightly + [r2r](https://github.com/sequenceplanner/r2r))
and Python (uv-managed) alongside the ROS2 C++/Python toolchain.

Extracted from a real project's devenv setup after finding and fixing several
non-obvious nix-ros-overlay/devenv interactions (see "Gotchas already fixed
for you" below) -- the point of this template is to skip re-discovering those.

## Using this template

`~/projects/NOflake/flake.nix` exposes this directory as a Nix flake
template (`templates.devenv-ros`), so a new project pulls the whole tree via
Nix's own template mechanism -- no manual copying, and it won't clobber
files that already exist in the target directory:

```
mkdir my-new-project && cd my-new-project
nix flake init -t path:/home/tao/projects/NOflake#devenv-ros
git init && git add -A   # or: jj git init --colocate
```

(`nix flake show path:/home/tao/projects/NOflake` lists what's available
there if this grows more than one template.)

Then:

1. In `devenv.nix`: rename `name = "CHANGEME"` (also in `pyproject.toml`).
   The `ros-env` buildEnv's `paths` list ships with a real fleet's full
   dependency set (mavros/PCL/GStreamer/etc, clearly marked "carried over
   from voxel") below a short generic starter set -- keep whatever this
   project actually needs and delete the rest, or leave it all in if this
   project is voxel-adjacent too. Same pattern in `languages.python`'s
   package list and the plain `packages` list. Delete the `languages.rust`/
   `languages.python` blocks entirely if you're not using one of those
   languages.
2. Put your ROS2 packages under `ros2_ws/src/`.
3. `devenv shell` to enter the environment (or `devenv shell -- hx .` to
   launch Helix inside it directly).
4. `devenv tasks run ros2ws:build` to build the workspace (see below for why
   this isn't automatic on shell entry).

## Architecture

- **`devenv.yaml`** pins `nixpkgs` to follow `nix-ros-overlay`'s own pinned
  nixpkgs (not the other way around) -- this keeps the ROS package set and
  everything else you pull from `pkgs` on one consistent nixpkgs revision, so
  e.g. Python ABI versions actually line up between `rclpy` and your own
  `languages.python.package`.
- **`vendor/default.nix`** is an empty overlay stub, applied after
  nix-ros-overlay in `devenv.nix`'s `overlays` list, for one-off package
  overrides. Keep it empty until you actually need it -- see the comment
  inside for a cautionary tale about reaching for an overlay override when
  the real fix belongs in your own package's `CMakeLists.txt` instead.
- **`ros2_ws/`** is a plain colcon workspace. This template doesn't prescribe
  how you manage the repos under `ros2_ws/src/` (plain git submodules, vcstool,
  separate checkouts, whatever fits your team) -- add that convention
  yourself.
- **`.helix/languages.toml`** and **`.cargo/config.toml`** are project-shared
  editor/build config, generic to any Rust+C/C++ ROS workspace -- copied
  as-is, no per-project edits needed.

## Gotchas already fixed for you

- **`colcon build` "Argument list too long."** nixpkgs' compiler-wrapper setup
  hooks duplicate `NIX_CFLAGS_COMPILE`/`NIX_LDFLAGS` entries 4-6x per package
  (a known, still-open nixpkgs bug -- NixOS/nixpkgs#41340, NixOS/nix#5593 --
  that hits nix-ros-overlay especially hard since a ROS workspace pulls in
  dozens of packages). Once the duplicated content crosses Linux's fixed
  128KB `MAX_ARG_STRLEN` per-string cap, `execve()` fails for anything that
  inherits the bloated env var. This is a *different* limit from `ulimit -s`
  (`ARG_MAX`) -- raising the stack ulimit does nothing here. Fixed by
  deduplicating both vars (a pair-aware dedup, since flags like `-isystem`
  take a following value that must move with them) in both `enterShell` and
  the `ros2ws:build` task -- see `dedupeFlagsShellFunction` in `devenv.nix`.
- **`ament_cmake` compiler detection fails with "cannot find Scrt1.o"/`-lgcc`.**
  `languages.rust`'s `clangLinker` leaves bare `clang`/`clang++` on PATH
  pointing at the *unwrapped* compiler (fine for Cargo, which doesn't use
  `CC`/`CXX`) -- but CMake's own compiler detection does read `CC`/`CXX`, and
  the unwrapped clang has no glibc sysroot/crt wiring. Pinned to `pkgs.gcc`
  instead in both the `env` block and `ros2ws:build` (there's a known,
  unresolved quirk where the `env` block's own CC/CXX doesn't reliably win in
  a plain interactive shell -- see the `KNOWN BROKEN` comment in `devenv.nix`).
- **bindgen (r2r etc.) can't find `<stdio.h>`.** bindgen calls libclang
  directly, bypassing the compiler wrapper that normally injects Nix's
  include paths. Fixed via `BINDGEN_EXTRA_CLANG_ARGS`.
- **`colcon build` re-running on every shell entry.** Naive mtime checks
  against `install/` don't work (colcon only bumps a directory's own mtime on
  add/remove of an immediate child, not on rewrites inside an existing
  package dir) and matching "any file under `src/`" re-triggers on README/
  gitignore edits. Fixed with a stamp file (`.devenv-last-build`) compared
  against an allowlist of build-relevant file patterns.
- **clangd can't find `compile_commands.json`.** colcon writes it under
  `build/<pkg>/`, not next to sources, and packages aren't necessarily one
  level deep. `ros2ws:build` symlinks it into each package's source dir using
  colcon's own name -> path mapping.

## If you're adding Rust (r2r)

Keep `languages.rust.channel = "nightly"` -- required for the Cranelift dev
codegen backend and `-Z threads`, which are there purely for compile-time
iteration speed and unrelated to r2r itself. r2r's own `build.rs` does real
codegen (bindgen), so `cranelift.forceBuildScriptsLlvm = true` keeps build
scripts/proc macros on the better-tested LLVM backend and reserves Cranelift
for your own crate's dev-build loop.

r2r needs no colcon plugins (unlike `rclrs`/ros2_rust, which needs
`colcon-cargo`/`colcon-ros-cargo`/`cargo-ament-build` -- real extra work under
Nix, since `nix-ros-overlay`'s `buildRosPackage` has no built-in `ament_cargo`
support). r2r's own colcon integration works via a `dummy.c`/CMake shim
(`r2r_cargo.cmake`) that makes `ament_cmake` shell out to `cargo build`.

## Known environment gotcha (not this template's bug)

`devenv` 2.3.0/2.3.1 as currently packaged in nixpkgs can crash interactive
`devenv shell` sessions with:

```
× Shell session error
 ─▶ terminal error: invalid value
 ─▶ invalid value
```

Root cause: nixpkgs builds devenv against an outdated `libghostty-vt` that
doesn't match the ghostty-bindings revision devenv 2.3.x's Rust code expects
(ABI mismatch -> `GHOSTTY_INVALID_VALUE`). It's deterministic and
terminal-independent (reproduces even in a bare TTY / a raw `openpty()`
harness) -- see [cachix/devenv#3183](https://github.com/cachix/devenv/issues/3183).
`--no-tui`/`DEVENV_TUI=false` do **not** avoid it (separately,
`DEVENV_TUI` itself doesn't actually work due to a clap parsing bug --
cachix/devenv#2646). Non-interactive invocations (`devenv shell -- <cmd>`)
are unaffected. Fix is nixpkgs PR
[#563205](https://github.com/NixOS/nixpkgs/pull/563205); until it lands,
either pin your system's `devenv` package to 2.2.2, or run
`nix run github:cachix/devenv/v2.3.1 -- shell` directly.
