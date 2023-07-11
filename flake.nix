{
  description = "we say NO to shitty OSes";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-23.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      # pkgs = import nixpkgs {
      #   config.allowUnfree = true;
      # };
      nixosSystem = (systemModules: inputs.nixpkgs.lib.nixosSystem { modules = systemModules; });
      base = ./systems/BASED.nix;
      nixos-hw = inputs.nixos-hardware.nixosModules;
    in
    {
      nixosConfigurations = {
        NOcomputer = nixosSystem [
          base
          nixos-hw.common-cpu-amd
          nixos-hw.common-gpu-nvidia
          ./systems/NOcomputer.nix
          ./uwuraid.nix
          ./gaming.nix
          ./users/tao.nix
        ];
        NOlaptop = nixosSystem [
          # inputs.nixos-hardware.nixosModules.framework
          base
          ./systems/NOlaptop.nix
          ./uwuraid.nix
          ./gaming.nix
          ./users/tao.nix
        ];
      };


    };
}
