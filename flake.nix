{
  description = "we say NO to shitty OSes";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { pkgs, ... }@inputs:
    let
      base = ./systems/BASED.nix;
      nixos-hw = inputs.nixos-hardware.nixosModules;
    in
    {
      nixosConfigurations = {
        NOcomputer = pkgs.lib.nixosSystem [
          base
          nixos-hw.common-cpu-amd
          nixos-hw.common-gpu-nvidia
          ./systems/NOcomputer.nix
          ./uwuraid.nix
          ./gaming.nix
          ./users/tao.nix
        ];
        NOlaptop = pkgs.lib.nixosSystem [
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
