{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # prescurve
    powertop
    fw-ectool
  ];

  powerManagement.powertop.enable = true;
  services.fwupd.enable = true;
  services.fprintd.enable = true;

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
    "nvme.noacpi=1"
  ];
  boot.kernelModules = ["kvm-amd"];
  powerManagement.cpuFreqGovernor = "powersave";
  systemd.sleep.extraConfig = "HibernateDelaySec=180m";

  networking.hostName = "NOlaptop";
}
