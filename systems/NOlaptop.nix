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
    # TLB-flush fixes -- confirmed over 20+ boots: the compbuf regression is
    # gone (0 occurrences), so that part of the bet paid off. Keep this pin.
    #
    # Separately, the 780M iGPU (gfx1103) has an unresolved MES/gfxoff hang --
    # "Failed to disable gfxoff!" / "MES failed to respond" / failed GPU
    # resets. As of 2026-09-19, tested and ruled out as kernel-version-fixable:
    # it reproduces identically on 6.17.13, 6.18.48, 6.18.50, and 7.2.5, and
    # a hand-adapted unmerged amd-gfx patch (disallow gfxoff around GFX11
    # queue reset) didn't stop it either -- see git history / the bug report
    # at extras/patches/gitlab-3731-ftpm-psp-correlation-report.md for why.
    # Every crash instance examined shows an fTPM operation timeout 1-2s
    # before amdgpu reacts, and a firmware TPM on this platform lives inside
    # the PSP -- strongest working theory is a PSP-level stall that MES,
    # SMU/gfxoff, and fTPM all depend on, which would explain why it follows
    # across every kernel/driver combination tried. amdgpu.cwsr_enable=0 and
    # the gfxoff patch were both removed after being carried for weeks
    # without ever coinciding with a crash-free stretch distinguishable from
    # chance -- keeping unproven mitigations around was adding build cost
    # (full local kernel compiles) and noise for no demonstrated benefit.
    # Revisit if a real fix lands upstream, or if the PSP-stall theory turns
    # up something actionable.
    # https://community.frame.work/t/amd-gpu-mes-timeouts-causing-system-hangs-on-framework-laptop-13-amd-ai-300-series/71364
    # https://community.frame.work/t/attn-critical-bugs-in-amdgpu-driver-included-with-kernel-6-18-x-6-19-x/79221
    boot.kernelPackages = punstable.linuxPackages_7_2;
    boot.kernelParams = [
        "amdgpu.gpu_recovery=1"
        "amdgpu.abmlevel=1"
        # dcdebugmask is a bitmask into enum DC_DEBUG_MASK (amd_shared.h):
        # 0x10 = DC_DISABLE_PSR (Panel Self Refresh), 0x400 = DC_DISABLE_REPLAY
        # (Panel Replay, PSR's newer sibling -- same family of eDP
        # power-saving feature, same class of hang risk). 0x10 alone is the
        # documented fix for PSR hangs on this eDP panel:
        # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
        # nixos-hardware's framework-16-7040-amd module also sets 0x10 alone,
        # but boot.kernelParams is a list, so both entries land on the
        # cmdline and the driver takes the *last* dcdebugmask=, silently
        # discarding nixos-hardware's 0x10. Merge both bits here so our
        # entry carries the PSR fix too regardless of module ordering, and
        # preemptively disable Replay too since it's the same failure family.
        "amdgpu.dcdebugmask=0x410"
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
