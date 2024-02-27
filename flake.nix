{
  description = "we say NO to shitty OSes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "nixos-hardware";
    nixos-raspberrypi.url = "github:ramblurr/nixos-raspberrypi";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    jujutsu.url = "github:martinvonz/jj";
    jujutsu.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    # aagl.inputs.nixpkgs.follows = "nixpkgs";

    # prescurve.url = "github:taotien/prescurve";
    # prescurve.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    nixos-raspberrypi,
    home-manager,
    helix,
    jujutsu,
    stylix,
    ...
  } @ inputs: {
    nixosConfigurations = {
      NOcomputer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          ./systems/BASED.nix
          ./systems/NOcomputer.nix
          ./users/tao.nix
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          ./extras/uwuraid.nix
          ./extras/dev.nix
          ./extras/gaming.nix
          ./extras/cosmic.nix
        ];
      };
      NOlaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.common-cpu-intel
          # inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
          ./systems/BASED.nix
          ./systems/NOlaptop.nix
          ./users/tao.nix
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          ./extras/uwuraid.nix
          ./extras/dev.nix
          ./extras/gaming.nix
          ./extras/cosmic.nix
        ];
      };
      # NObangers = nixos-system [
      #   # ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable-arm ]; })
      #   nixos-hw.raspberry-pi-4
      #   nixos-rpi.hardware
      #   ./systems/BASED.nix
      #   ./systems/NObangers.nix
      #   ./users/pi.nix
      #   ./extras/uwuraid.nix
      # ];
    };
  };
}
