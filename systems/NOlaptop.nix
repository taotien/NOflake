{
    lib,
    config,
    pkgs,
    inputs,
    ...
}: let
    punstable = import inputs.nixpkgs-unstable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
    };
in {
    # nixpkgs.overlays = [
    #   (final: prev: {
    #     libinput = prev.libinput.overrideAttrs (old: {
    #       patches =
    #         (old.patches or [])
    #         ++ [
    #           ../extras/libinput-delay.patch
    #         ];
    #     });
    #   })
    # ];

    environment.systemPackages = with pkgs; [
        # keep-sorted start
        framework-tool
        fw-ectool
        # lact
        nvtopPackages.amd
        # keep-sorted end
    ];

    services.lact.enable = true;

    services.tailscale.useRoutingFeatures = "client";
    systemd.services."backlight@backlight:amdgpu_bl2".enable = false;

    services.udev.extraRules = ''
        # ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
        # ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"

        ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"
        ACTION=="add|change", KERNEL=="i2c", SUBSYSTEM=="i2c", DEVPATH=="/sys/devices/platform/AMDI0010:03/i2c-1/i2c-PIXA3854:00", ATTR{power/wakeup}="disabled"

        # ACTION=="add", SUBSYSTEM=="acpi", DRIVERS=="button", ATTRS{hid}=="PNP0C0D", ATTR{power/wakeup}="disabled"
        # ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
        # ACTION=="add", SUBSYSTEM=="i2c", DRIVERS=="i2c_hid_acpi", ATTRS{name}=="PIXA3854:00", ATTR{power/wakeup}="disabled"
    '';

    services.fprintd.enable = true;

    services.xserver.videoDrivers = [
        "amdgpu"
    ];

    # On linuxPackages_6_18, the dGPU had an amdgpu regression that hung the
    # display on runtime-suspend wake (REG_WAIT timeout in
    # dcn31_program_compbuf_size). Switched to nixpkgs-unstable's 7.2.5 for
    # its "force complete the MES ring fences on reset" + MES-eviction
    # TLB-flush fixes -- confirmed over 8 boots: the compbuf regression is
    # gone (0 occurrences), so that part of the bet paid off.
    # Still open: the 780M iGPU (gfx1103) MES/gfxoff hang -- "Failed to
    # disable gfxoff!" / "MES failed to respond" / failed GPU resets --
    # recurred on 3 of those 8 boots despite amdgpu.cwsr_enable=0 below.
    # Staying on 7.2.5 since it's now strictly no-worse-than-6.18 (fixed one
    # of the two known bugs, didn't reintroduce the other). No kernel version
    # has a confirmed fix for the MES hang on this exact chip; revisit if a
    # real fix lands upstream, or fall back via nixpkgs-kernel-pin (6.17,
    # see flake.nix) if 7.2.5 gets worse.
    # https://community.frame.work/t/amd-gpu-mes-timeouts-causing-system-hangs-on-framework-laptop-13-amd-ai-300-series/71364
    # https://community.frame.work/t/attn-critical-bugs-in-amdgpu-driver-included-with-kernel-6-18-x-6-19-x/79221
    boot.kernelPackages = punstable.linuxPackages_7_2;
    # Testing an unmerged upstream fix for the MES/gfxoff hang above -- see
    # extras/patches/amdgpu-gfx11-disallow-gfxoff-around-gpu-reset.patch for
    # the full story (amd-gfx list, still under review as of 2026-09-16).
    boot.kernelPatches = [
        {
            name = "amdgpu-gfx11-disallow-gfxoff-around-gpu-reset";
            patch = ../extras/patches/amdgpu-gfx11-disallow-gfxoff-around-gpu-reset.patch;
        }
    ];
    boot.kernelParams = [
        "amdgpu.gpu_recovery=1"
        "amdgpu.abmlevel=1"
        # 0x10 disables PSR (nixos-hardware's framework-16-7040-amd module also
        # sets 0x10 alone, as the documented fix for PSR hangs on the eDP panel:
        # https://gitlab.freedesktop.org/drm/amd/-/issues/3647 -- but
        # boot.kernelParams is a list, so both entries land on the cmdline and
        # the driver takes the *last* dcdebugmask=, silently discarding
        # nixos-hardware's 0x10. Merge both bits (0x10 | 0x400) here so our
        # entry carries the PSR fix too regardless of module ordering.
        "amdgpu.dcdebugmask=0x410"
        # Mitigation for MES (Micro Engine Scheduler) firmware hangs on the
        # 780M iGPU (gfx1103) under normal desktop use (browser/compositor
        # GPU accel) -- "MES failed to respond", escalating to failed GPU
        # resets and full system hangs. Open upstream bug, confirmed on the
        # same 7840HS/780M hardware; amdgpu.cwsr_enable=0 was the mitigation
        # with actual reported effect (amdgpu.mes=0 only partially helped):
        # https://community.frame.work/t/amd-gpu-mes-timeouts-causing-system-hangs-on-framework-laptop-13-amd-ai-300-series/71364
        "amdgpu.cwsr_enable=0"
        # amdgpu.mes=0 (the other partial mitigation from the same thread) was
        # here too, but on 7.2.5 amdgpu logs "unknown parameter 'mes' ignored"
        # -- that param no longer exists in this kernel's amdgpu build, so it
        # was dead weight. Dropped.
    ];
    boot.kernelModules = ["amdgpu"];
    powerManagement.cpuFreqGovernor = "powersave";
    # systemd.sleep.extraConfig = "HibernateDelaySec=360m";

    nix.settings = {
        connect-timeout = 5;
    };
    nix.buildMachines = [
        {
            hostName = "nocomputer";
            systems = ["x86_64-linux" "i686-linux"];
            supportedFeatures = [
                "benchmark"
                "big-parallel"
                "gccarch-znver4"
                "kvm"
                "nixos-test"
            ];
        }
    ];
    nix.extraOptions = ''
        builders-use-substitutes = true
    '';
    nix.distributedBuilds = true;

    networking.hostName = "NOlaptop";
}
