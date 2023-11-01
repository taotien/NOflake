{ pkgs, prescurve, ... }: {
  environment.systemPackages = with pkgs; [
    prescurve
    intel-gpu-tools
    # libsForQt5.skanpage
    powertop
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

  # hardware.sane = {
  #   enable = true;
  #   extraBackends = [ pkgs.epkowa ];
  # };

  services.xserver.displayManager.defaultSession = "plasmawayland";

  # systemd.user.services.backlight = {
  #   # description = "";
  #   ExecStart = "${pkgs.prescurve}/bin/prescurve_backlight";
  #   Restart = "on-failure";
  #   wantedBy = [ "default.target" ];
  # };


  # SUBSYSTEM=="backlight", GROUP="video", MODE="0664"
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

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
    "i915.eanble_psr=1"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  powerManagement.cpuFreqGovernor = "powersave";
  systemd.sleep.extraConfig = "HibernateDelaySec=60m";

  services.pipewire.wireplumber.enable = true;
  environment.etc = {
    "wireplumber/main.lua.d/51-fix-static.lua".text = ''
      rule = {
        matches = {
          {
            { "node.name", "equals", "alsa_output.pci-0000_00_1f.3.analog-stereo.3" },
          },
        },
        apply_properties = {
          [ "audio.format" ] = "S24LE" ,
        },
      }
      table.insert(alsa_monitor.rules, rule)
    '';
  };

  networking.hostName = "NOlaptop";
}
