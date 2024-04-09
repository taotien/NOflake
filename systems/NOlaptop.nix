{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # fw-ectool
    framework-tool
    nvtopPackages.amd
  ];

  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;
  services.fprintd.enable = true;

  # stop using this: https://community.frame.work/t/tracking-ppd-v-tlp-for-amd-ryzen-7040/39423/9?u=ghett_klapson
  # powerManagement.powertop.enable = false;
  # systemd.services.powertop = {
  #   wantedBy = ["multi-user.target"];
  #   after = ["multi-user.target"];
  #   path = [pkgs.kmod];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = "yes";
  #     ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
  #     ExecStartPost = "/bin/sh -c 'for f in $(grep -l \"Keyboard\\|Preonic\\|Razer\\|Macropad\" /sys/bus/usb/devices/*/product | sed \"s/product/power\\\\/control/\"); do echo on >| '$f'; done'";
  #   };
  # };

  environment.etc = {
    "libinput/local-overrides.quirks".text = "
# MatchUdevType=touchpad
# MatchDMIModalias=dmi:*svnFramework:pnLaptop*
# AttrEventCode=-BTN_RIGHT

[Framework Laptop 16 Keyboard Module]
MatchName=Framework Laptop 16 Keyboard Module*
# MatchUdevType=keyboard
# MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
AttrKeyboardIntegration=internal";
  };

  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = ["tao"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = "5";
      TIMELINE_LIMIT_DAILY = "7";
    };
  };
  services.snapper.snapshotInterval = "*:0/5";

  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [
    "nvme"
    "sd_mod"
    "thunderbolt"
    "usb_storage"
    "xhci_pci"
    "usbhid"
    "uas"
  ];
  boot.kernelParams = [
    # "mem_sleep_default=deep"
    # "nvme.noacpi=1"
    "amdgpu.abmlevel=1"
  ];
  boot.kernelModules = ["kvm-amd"];
  # boot.extraModulePackages = [  ];
  powerManagement.cpuFreqGovernor = "powersave";
  systemd.sleep.extraConfig = "HibernateDelaySec=180m";

  fileSystems."/home/tao/games" = {
    device = "/dev/disk/by-uuid/d97a81dc-669c-41d1-912b-829f88fd6f69";
    fsType = "btrfs";
    options = ["subvol=/home/tao/games" "nosuid" "nodev" "noatime" "compress-force=zstd:3" "users" "rw" "exec" "discard=async"];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/d97a81dc-669c-41d1-912b-829f88fd6f69";
    fsType = "btrfs";
    options = ["subvol=home" "noatime" "compress-force=zstd:3" "discard=async"];
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d97a81dc-669c-41d1-912b-829f88fd6f69";
    fsType = "btrfs";
    options = ["noatime" "compress-force=zstd:3" "discard=async"];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8E28-E53F";
    fsType = "vfat";
  };
  swapDevices = [{device = "/dev/disk/by-uuid/36216521-db46-4bb0-8994-38a36d5c4528";}];

  networking.hostName = "NOlaptop";
}
