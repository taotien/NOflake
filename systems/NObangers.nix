{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    raspberrypi-eeprom
  ];
  programs.partition-manager.enable = false;

  services.printing.enable = false;
  i18n.inputMethod = {};

  services.xserver.enable = false;
  services.desktopManager.plasma6.enable = false;

  services.pipewire.enable = false;
  services.pulseaudio.enable = true;
  config.hardware.raspberry-pi."4" = {
    bluetooth.enable = true;
    # fkms-3d.enable = true;
  };

  users.users.tao = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.password-tao.path;
    extraGroups = ["audio" "video" "wheel" "libvirtd" "dialout" "game"];
    shell = pkgs.nushell;
  };

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;

  # Configure for modesetting in the device tree
  hardware.deviceTree = {
    overlays = [
      # Equivalent to:
      # https://github.com/raspberrypi/linux/blob/rpi-6.1.y/arch/arm/boot/dts/overlays/cma-overlay.dts
      {
        name = "rpi4-cma-overlay";
        dtsText = ''
          // SPDX-License-Identifier: GPL-2.0
          /dts-v1/;
          /plugin/;

          / {
            compatible = "brcm,bcm2711";

            fragment@0 {
              target = <&cma>;
              __overlay__ {
                size = <(512 * 1024 * 1024)>;
              };
            };
          };
        '';
      }
      # Equivalent to:
      # https://github.com/raspberrypi/linux/blob/rpi-6.1.y/arch/arm/boot/dts/overlays/vc4-fkms-v3d-overlay.dts
      {
        name = "rpi4-vc4-fkms-v3d-overlay";
        dtsText = ''
          // SPDX-License-Identifier: GPL-2.0
          /dts-v1/;
          /plugin/;

          / {
            compatible = "brcm,bcm2711";

            fragment@1 {
              target = <&fb>;
              __overlay__ {
                status = "disabled";
              };
            };

            fragment@2 {
              target = <&firmwarekms>;
              __overlay__ {
                status = "okay";
              };
            };

            fragment@3 {
              target = <&v3d>;
              __overlay__ {
                status = "okay";
              };
            };

            fragment@4 {
              target = <&vc4>;
              __overlay__ {
                status = "okay";
              };
            };
          };
        '';
      }
    ];
  };
  # Also configure the system for modesetting.
  services.xserver.videoDrivers = lib.mkBefore [
    "modesetting" # Prefer the modesetting driver in X11
    "fbdev" # Fallback to fbdev
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  nix.buildMachines = [
    {
      hostName = "nolaptop";
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

  networking.hostName = "NObangers";
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "23.11";
}
