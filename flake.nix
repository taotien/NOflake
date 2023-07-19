{
  description = "we say NO to shitty OSes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "nixos-hardware";
  };

  outputs = { nixpkgs, nixos-hardware, nixpkgs-unstable, ... }:
    let
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
      };
      nixosSystem = (systemModules: nixpkgs.lib.nixosSystem { modules = systemModules; });
      nixos-hw = nixos-hardware.nixosModules;
    in
    {
      nixosConfigurations = {
        NOcomputer = nixosSystem [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          nixos-hw.common-cpu-amd
          nixos-hw.common-gpu-nvidia-nonprime
          ./systems/BASED.nix
          ./systems/NOcomputer.nix
          ./uwuraid.nix
          ./gaming.nix
          ./users/tao.nix
        ];
        NOlaptop = nixosSystem [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          nixos-hw.common-cpu-intel
          # inputs.nixos-hardware.nixosModules.framework
          ./systems/BASED.nix
          ./systems/NOlaptop.nix
          ./uwuraid.nix
          ./gaming.nix
          ./users/tao.nix
        ];
      };


    };
}
