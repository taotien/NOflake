{
  description = "we say NO to shitty OSes";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "nixos-hardware";
    nixos-raspberrypi.url = "github:ramblurr/nixos-raspberrypi";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    # hyprland.url = "github:hyprwm/Hyprland";
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    # aagl.inputs.nixpkgs.follows = "nixpkgs";

    # prescurve.url = "github:taotien/prescurve";
    # prescurve.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    # extra-substituters = [ "https://hyprland.cachix.org" "https://ezkea.cachix.org" ];
    # extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
    extra-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # outputs = { self, nixpkgs, nixos-hardware, nixos-raspberrypi, home-manager, helix, aagl, ... }@inputs:
  outputs = { self, nixpkgs, nixos-hardware, nixos-raspberrypi, home-manager, helix, ... }@inputs:
    {
      nixosConfigurations = {
        NOcomputer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            ./systems/BASED.nix
            ./systems/NOcomputer.nix
            ./users/tao.nix
            home-manager.nixosModules.home-manager
            ./extras/uwuraid.nix
            ./extras/dev.nix
            ./extras/gaming.nix
            ./extras/cosmic.nix
          ];
        };
        NOlaptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.common-cpu-intel
            # inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
            ./systems/BASED.nix
            ./systems/NOlaptop.nix
            ./users/tao.nix
            home-manager.nixosModules.home-manager
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
