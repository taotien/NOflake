{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # prescurve
    libinput
    powertop
    fw-ectool
  ];

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  powerManagement.powertop.enable = false;
  systemd.services.powertop = {
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
    path = [pkgs.kmod];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
      ExecStartPost = "
          /bin/sh -c 'for f in $(grep -l 'Keyboard' /sys/bus/usb/devices/*/product | sed \"s/product\\\\power/control/\"); do echo on >| '$f'; done'
        ";
    };
  };

  # environment.etc = {
  #   "libinput/local-overrides.quirks".text = "
  #     # MatchUdevType=touchpad
  #     # MatchDMIModalias=dmi:*svnFramework:pnLaptop*
  #     # AttrEventCode=-BTN_RIGHT

  #     [Framework Laptop 16 Keyboard Module]
  #     MatchName=Framework Laptop 16 Keyboard Module*
  #     MatchUdevType=keyboard
  #     # MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
  #     AttrKeyboardIntegration=internal
  #   ";
  # };
  # services.xserver.libinput = {
  #   enable = true;
  #   touchpad.disableWhileTyping = true;
  # };

  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;

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
  ];
  boot.kernelModules = ["kvm-amd"];
  powerManagement.cpuFreqGovernor = "powersave";
  systemd.sleep.extraConfig = "HibernateDelaySec=180m";

  networking.hostName = "NOlaptop";
}
