{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
  ];

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/e4244a97-9b48-49f0-8093-782163045020";
    fsType = "btrfs";
    options = [ "subvol=home-snaps/0/snapshot" "noatime" "compress-force=zstd:3" ];
  };
  fileSystems."/home/tao/Games" = {
    device = "/dev/disk/by-uuid/e4244a97-9b48-49f0-8093-782163045020";
    fsType = "btrfs";
    options = [ "subvol=games" "nosuid" "nodev" "noatime" "compress-force=zstd:3" "users" "rw" "exec" ];
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e4244a97-9b48-49f0-8093-782163045020";
    fsType = "btrfs";
    options = [ "subvol=nixos" "noatime" "compress-force=zstd:3" ];
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/ca55d0ea-c0db-44c5-af3a-e38eec803929"; }];

  services.fprintd.enable = true;
  services.fwupd.enable = true;
  powerManagement.powertop.enable = true;
  hardware.sensor.iio.enable = true;

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epkowa ];
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "sd_mod"
    "thunderbolt"
    "usb_storage"
    "xhci_pci"
  ];
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "nvme.noacpi=1"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  powerManagement.cpuFreqGovernor = "powersave";
  systemd.sleep.extraConfig = "HibernateDelaySec=60m";

  networking.hostName = "NOlaptop";
}
