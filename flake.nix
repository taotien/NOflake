{
  description = "we say NO to shitty OSes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "nixos-hardware";
    nixos-raspberrypi.url = "github:ramblurr/nixos-raspberrypi";
    # nixos-raspberrypi.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixos-hardware, nixpkgs-unstable, nixos-raspberrypi, ... }:
    let
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
      overlay-unstable-arm = final: prev: {
        unstable = import nixpkgs-unstable {
          system = "aarch64-linux";
          config.allowUnfree = true;
          # config.allowUnsupportedSystem = true;
        };
      };
      nixosSystem = (systemModules: nixpkgs.lib.nixosSystem { modules = systemModules; });
      nixos-hw = nixos-hardware.nixosModules;
      nixos-rpi = nixos-raspberrypi.nixosModules;
    in
    {
      nixosConfigurations = {
        NOcomputer = nixosSystem [
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
        NOlaptop = nixosSystem [
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
        NObangers = nixosSystem [
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
