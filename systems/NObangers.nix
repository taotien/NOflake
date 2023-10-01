{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
    autoResize = true;
  };
  programs.partition-manager.enable = false;

  services.printing.enable = false;
  services.btrfs.autoScrub.enable = false;

  boot = {
    # initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    initrd.availableKernelModules = [ "xhci_pci" ];
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
      # filter = "bcm2711-rpi-4-*.dtb";
    };
  };

  hardware.deviceTree.overlays = [{
    name = "hifiberry-dacplusadc";
    dtsText = ''
      // Definitions for HiFiBerry DAC+
      /dts-v1/;
      /plugin/;

      / {
        compatible = "brcm,bcm2711";

        fragment@0 {
          target-path = "/";
          __overlay__ {
            dacpro_osc: dacpro_osc {
              compatible = "hifiberry,dacpro-clk";
              #clock-cells = <0>;
            };
          };
        };

        fragment@1 {
          target = <&i2s>;
          __overlay__ {
            status = "okay";
          };
        };

        fragment@2 {
          target = <&i2c1>;
          __overlay__ {
            #address-cells = <1>;
            #size-cells = <0>;
            status = "okay";

            pcm5122@4d {
              #sound-dai-cells = <0>;
              compatible = "ti,pcm5122";
              reg = <0x4d>;
              clocks = <&dacpro_osc>;
              AVDD-supply = <&vdd_3v3_reg>;
              DVDD-supply = <&vdd_3v3_reg>;
              CPVDD-supply = <&vdd_3v3_reg>;
              status = "okay";
            };
            hpamp: hpamp@60 {
              compatible = "ti,tpa6130a2";
              reg = <0x60>;
              status = "disabled";
            };
          };
        };

        fragment@3 {
          target = <&sound>;
          hifiberry_dacplus: __overlay__ {
            compatible = "hifiberry,hifiberry-dacplus";
            i2s-controller = <&i2s>;
            status = "okay";
          };
        };

        __overrides__ {
          24db_digital_gain =
            <&hifiberry_dacplus>,"hifiberry,24db_digital_gain?";
          slave = <&hifiberry_dacplus>,"hifiberry-dacplus,slave?";
          leds_off = <&hifiberry_dacplus>,"hifiberry-dacplus,leds_off?";
        };
      };
    '';
  }];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "23.11";
  networking.hostName = "NObangers";
}
