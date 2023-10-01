{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
    # autoResize = true;
  };
  programs.partition-manager.enable = false;

  services.printing.enable = false;
  services.btrfs.autoScrub.enable = false;

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" "vc4" "pcie_brcmstb" "reset-raspberrypi" ];
    # initrd.availableKernelModules = [ "xhci_pci" ];
    kernelParams = [
      "8250.nr_uarts=1"
      "cma=128M"
      "console=tty1"
      # "console=ttyAMA0,115200"
    ];
    loader = {
      raspberryPi = {
        enable = true;
        version = 4;
      };
      systemd-boot.enable = false;
      generic-extlinux-compatible.enable = false;
    };
    kernelPackages = pkgs.linuxPackages_rpi4;
  };

  # powerManagement.cpuFreqGovernor = "ondemand";

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      # audio.enable = true;
      fkms-3d.enable = true;
    };
    deviceTree = {
      enable = true;
    };
  };

  raspberry-pi.hardware.platform.type = "rpi4";
  raspberry-pi.hardware.hifiberry-dacplus.enable = true;

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "23.11";
  networking.hostName = "NObangers";
}
