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
      nixos-hw = inputs.nixos-hardware.nixosModules;
    in
    {
      nixosConfigurations = {
        NOcomputer = nixosSystem [
          nixos-hw.common-cpu-amd
          nixos-hw.common-gpu-nvidia
          ./systems/NOcomputer.nix
          ./uwuraid.nix
          ./gaming.nix
          ./users/tao.nix
        ];
        NOlaptop = nixosSystem [
          # inputs.nixos-hardware.nixosModules.framework
          ./systems/NOlaptop.nix
          ./uwuraid.nix
          ./gaming.nix
          ./users/tao.nix
        ];
      };


    };
}
