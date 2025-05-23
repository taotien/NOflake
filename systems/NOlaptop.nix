{
  lib,
  config,
  pkgs,
  ...
}:
# let
#   boostless = pkgs.pipewire.overrideAttrs (old: {
#     postInstall =
#       old.postInstall or ""
#       + ''
#       '';
#   });
# in
{
  environment.etc."alsa-card-profile/analog-input-internal-mic.conf".source = ../extras/analog-input-internal-mic.conf;

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  # services.pipewire.wireplumber.extraConfig = {
  #   "wireplumber.settings" = {
  #     "device.routes.default-source-volume" = 0.42;
  #   };
  # };

  services.rsyslogd = {
    enable = true;
    extraConfig = ''
      module(load="imudp")
      input(type="imudp" port="514")

      THENAS.*  -/var/log/THENAS
    '';
  };

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
    lact
  ];

  systemd.services.lactd.wantedBy = ["multi-user.target"];

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

    ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"
    ACTION=="add|change", KERNEL=="i2c", SUBSYSTEM=="i2c", DEVPATH=="/sys/devices/platform/AMDI0010:03/i2c-1/i2c-PIXA3854:00", ATTR{power/wakeup}="disabled"

    # ACTION=="add", SUBSYSTEM=="acpi", DRIVERS=="button", ATTRS{hid}=="PNP0C0D", ATTR{power/wakeup}="disabled"
    # ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
    # ACTION=="add", SUBSYSTEM=="i2c", DRIVERS=="i2c_hid_acpi", ATTRS{name}=="PIXA3854:00", ATTR{power/wakeup}="disabled"
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
    # "amdgpu.dcdebugmask=0x400"
    # "mem_sleep_default=deep"
  ];
  # boot.kernelModules = ["kvm-amd"];
  boot.kernelModules = ["amdgpu"];
  powerManagement.cpuFreqGovernor = "powersave";
  systemd.sleep.extraConfig = "HibernateDelaySec=360m";

  networking.hostName = "NOlaptop";
}
