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

    # The internal mic exposes two ALSA gain stages -- "Capture" (-17.25..+30
    # dB) and "Mic Boost" (0..+30 dB in 10 dB steps) -- and PipeWire's ACP
    # mixer path for the active port, analog-input-mic.conf, declares
    # `volume = merge` on both. That stacks them into one slider, so a source
    # volume of 100% applies +60 dB and the capture is pure static. Anything
    # that resets the source to 100% (switching or plugging in another audio
    # device tends to) lands straight in that range.
    # https://community.frame.work/t/microphone-extremely-staticy/15533/12
    #
    # Patch "Mic Boost" out of the merge, capping the range at Capture's
    # +30 dB. ACP_PATHS_DIR *replaces* the built-in directory rather than
    # overlaying it, so the whole tree gets copied -- `-L` because the
    # .conf.common files are included by the paths that use them.
    #
    # Note the element here is plain "Mic Boost", not "Internal Mic Boost":
    # this codec has no discrete internal-mic control, so ACP picks the
    # analog-input-mic path and analog-input-internal-mic.conf is never read.
    #
    # WirePlumber is the process that actually loads the ALSA SPA device and
    # reads ACP_PATHS_DIR -- verified by handing the var to wireplumber.service
    # alone, which is enough on its own. pipewire.service gets it too, purely
    # so this keeps working if that ever moves into the daemon.
    #
    # Verify with `pactl list sources`: the analog source's "Base Volume"
    # reads -30 dB with this applied and -60 dB without, and Active Port
    # should still be analog-input-mic.
    acpPathsNoMicBoost = pkgs.runCommand "acp-mixer-paths-no-mic-boost" {} ''
        cp -rL ${config.services.pipewire.package}/share/alsa-card-profile/mixer/paths $out
        chmod -R u+w $out
        ${pkgs.python3}/bin/python3 ${../extras/acp-no-mic-boost.py} $out/analog-input-mic.conf
    '';
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

    systemd.user.services.pipewire.environment.ACP_PATHS_DIR = "${acpPathsNoMicBoost}";
    systemd.user.services.wireplumber.environment.ACP_PATHS_DIR = "${acpPathsNoMicBoost}";

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

    # boot.kernelPackages = punstable.linuxPackages_7_2;
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
        # cmdline and the driver takes the *last* dcdebugmask
        # "amdgpu.dcdebugmask=0x10"
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
