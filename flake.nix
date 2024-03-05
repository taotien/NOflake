{
  description = "we say NO to shitty OSes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "nixos-hardware";
    nixos-raspberrypi.url = "github:ramblurr/nixos-raspberrypi";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # stylix.url = "github:danth/stylix";
    helix = {
      url = "github:the-mikedavis/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jujutsu = {
      url = "github:martinvonz/jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    # aagl.inputs.nixpkgs.follows = "nixpkgs";

    # prescurve.url = "github:taotien/prescurve";
    # prescurve.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = ["https://cosmic.cachix.org/"];
    extra-trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    nixos-raspberrypi,
    home-manager,
    # stylix,
    helix,
    jujutsu,
    # nixos-cosmic,
    ...
  } @ inputs: {
    nixosConfigurations = {
      NOcomputer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          home-manager.nixosModules.home-manager
          # stylix.nixosModules.stylix
          ./systems/BASED.nix
          ./systems/NOcomputer.nix
          ./users/tao.nix
          ./extras/uwuraid.nix
          ./extras/dev.nix
          ./extras/gaming.nix
          # nixos-cosmic.nixosModules.default
          # ./extras/cosmic.nix
        ];
      };
      NOlaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.common-cpu-intel
          # inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
          home-manager.nixosModules.home-manager
          # stylix.nixosModules.stylix
          ./systems/BASED.nix
          ./systems/NOlaptop.nix
          ./users/tao.nix
          ./extras/uwuraid.nix
          ./extras/dev.nix
          ./extras/gaming.nix
        ];
      };
    };
  };
}
