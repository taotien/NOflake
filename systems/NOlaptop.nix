{
  lib,
  config,
  pkgs,
  ...
}: {
  services.rsyslogd = {
    enable = true;
    extraConfig = ''
      module(load="imudp")
      input(type="imudp" port="514")

      THENAS.*  -/var/log/THENAS
    '';
  };

  # boot.kernelPatches = [
  #   (lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "6.11")
  #     {
  #       name = "cros_ec_lpc";
  #       patch = pkgs.fetchpatch {
  #         url = "https://patchwork.kernel.org/series/840830/mbox/";
  #         sha256 = "sha256-7jSEAGInFC+a+ozCyD4dFz3Qgh2JrHskwz7UfswizFw=";
  #       };
  #     })
  # ];
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
    fw-ectool
    framework-tool
    nvtopPackages.amd
  ];

  services.fwupd.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  systemd.services."backlight@backlight:amdgpu_bl2".enable = false;

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

  services.udev.extraRules = ''
    # ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    # ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"

    # ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"
    # ACTION=="add|change", KERNEL=="i2c", SUBSYSTEM=="i2c", DEVPATH=="/sys/devices/platform/AMDI0010:03/i2c-1/i2c-PIXA3854:00", ATTR{power/wakeup}="disabled"
  '';

  services.fprintd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.initrd.availableKernelModules = [
  #   "nvme"
  #   "sd_mod"
  #   "thunderbolt"
  #   "usb_storage"
  #   "xhci_pci"
  #   "usbhid"
  #   "uas"
  # ];
  boot.kernelParams = [
    "amdgpu.abmlevel=1"
    "amdgpu.dcdebugmask=0x400"
  ];
  # boot.kernelModules = ["kvm-amd"];
  powerManagement.cpuFreqGovernor = "powersave";
  systemd.sleep.extraConfig = "HibernateDelaySec=360m";

  networking.hostName = "NOlaptop";
}
