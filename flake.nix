{
  description = "we say NO to shitty OSes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "nixos-hardware";
    nixos-raspberrypi.url = "github:ramblurr/nixos-raspberrypi";
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix/ee7b773dd7d028ad1b185cdf72bc16ce69ac0288";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    # prescurve.url = "github:taotien/prescurve";
    # prescurve.inputs.nixpkgs.follows = "nixpkgs";
  };

  # outputs = { nixpkgs, nixos-hardware, nixpkgs-unstable, nixos-raspberrypi, aagl, prescurve, ... }@attrs:
  outputs = { nixpkgs, nixos-hardware, nixpkgs-unstable, nixos-raspberrypi, aagl, ... }@attrs:
    let
      nixos-system = (systemModules: nixpkgs.lib.nixosSystem {
        modules = systemModules;
        specialArgs = attrs;
      });
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
          config.permittedInsecurePackages = [
            "electron-24.8.6"
            "qtwebkit-5.212.0-alpha4"
          ];
        };
      };
      overlay-unstable-arm = final: prev: {
        unstable = import nixpkgs-unstable {
          system = "aarch64-linux";
          config.allowUnfree = true;
          # config.allowUnsupportedSystem = true;
        };
      };
      nixos-hw = nixos-hardware.nixosModules;
      nixos-rpi = nixos-raspberrypi.nixosModules;
    in
    {
      nixosConfigurations = {
        NOcomputer = nixos-system [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          nixos-hw.common-cpu-amd
          nixos-hw.common-gpu-nvidia-nonprime
          ./systems/BASED.nix
          ./systems/NOcomputer.nix
          ./users/tao.nix
          ./extras/uwuraid.nix
          ./extras/dev.nix
          ./extras/gaming.nix
        ];
        NOlaptop = nixos-system [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          nixos-hw.common-cpu-intel
          # inputs.nixos-hardware.nixosModules.framework
          ./systems/BASED.nix
          ./systems/NOlaptop.nix
          ./users/tao.nix
          ./extras/uwuraid.nix
          ./extras/dev.nix
          ./extras/gaming.nix
        ];
        NObangers = nixos-system [
          # ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable-arm ]; })
          nixos-hw.raspberry-pi-4
          nixos-rpi.hardware
          ./systems/BASED.nix
          ./systems/NObangers.nix
          ./users/pi.nix
          ./extras/uwuraid.nix
        ];
      };
    };
}
