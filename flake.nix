{
  description = "we say NO to shitty OSes";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "nixos-hardware";
    nixos-raspberrypi.url = "github:ramblurr/nixos-raspberrypi";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # prescurve.url = "github:taotien/prescurve";
    # prescurve.inputs.nixpkgs.follows = "nixpkgs";
    inputs.hyprland.url = "github:hyprwm/Hyprland";
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix/ee7b773dd7d028ad1b185cdf72bc16ce69ac0288";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  outputs = { self, nixpkgs, nixos-hardware, nixos-raspberrypi, home-manager, aagl, ... }@attrs:
    {
      nixosConfigurations = {
        NOcomputer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
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
          ];
        };
        NOlaptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
          modules = [
            nixos-hardware.nixosModules.common-cpu-intel
            # inputs.nixos-hardware.nixosModules.framework
            ./systems/BASED.nix
            ./systems/NOlaptop.nix
            ./users/tao.nix
            home-manager.nixosModules.home-manager
            ./extras/uwuraid.nix
            ./extras/dev.nix
            ./extras/gaming.nix
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
