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

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2e1ba9af-4224-48a3-b935-519947da97db";
    fsType = "btrfs";
    options = ["subvol=home" "noatime" "compress-force=zstd:3" "discard=async"];
  };
  # fileSystems."/home/tao/Games" = {
  #   device = "/dev/disk/by-uuid/e4244a97-9b48-49f0-8093-782163045020";
  #   fsType = "btrfs";
  #   options = ["subvol=games" "nosuid" "nodev" "noatime" "compress-force=zstd:3" "users" "rw" "exec" "discard=async"];
  # };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2e1ba0af-4224-48a3-b935-519947da97db";
    fsType = "btrfs";
    options = ["subvol=nixos" "noatime" "compress-force=zstd:3" "discard=async"];
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
  boot.kernelModules = ["kvm-amd"];
  powerManagement.cpuFreqGovernor = "powersave";
  systemd.sleep.extraConfig = "HibernateDelaySec=180m";

  networking.hostName = "NOlaptop";
}
