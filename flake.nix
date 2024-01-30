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
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix/ee7b773dd7d028ad1b185cdf72bc16ce69ac0288";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, nixos-raspberrypi, home-manager, aagl, ... }:
    # let
    #   nixos-system = (systemModules: nixpkgs.lib.nixosSystem {
    #     modules = systemModules;
    #     specialArgs = attrs;
    #   });
    #   overlay-unstable = final: prev: {
    #     unstable = import nixpkgs {
    #       system = "x86_64-linux";
    #       config.allowUnfree = true;
    #       config.permittedInsecurePackages = [
    #         # "electron-24.8.6"
    #       ];
    #     };
    #   };
    #   # overlay-unstable-arm = final: prev: {
    #   #   unstable = import nixpkgs-unstable {
    #   #     system = "aarch64-linux";
    #   #     config.allowUnfree = true;
    #   #     # config.allowUnsupportedSystem = true;
    #   #   };
    #   # };
    #   nixos-hw = nixos-hardware.nixosModules;
    #   # nixos-rpi = nixos-raspberrypi.nixosModules;
    #   # overlay-home-manager = final: prev: {
    #   #   hw = import home-manager;
    #   # };
    # in
    {
      nixosConfigurations = {
        NOcomputer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          config.allowUnfree = true;
          modules = [
            nixos-hardware.common-cpu-amd
            nixos-hardware.common-gpu-nvidia-nonprime
            ./systems/BASED.nix
            ./systems/NOcomputer.nix
            # ./users/tao.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jdoe = import ./tao.nix;
            }
            ./extras/uwuraid.nix
            ./extras/dev.nix
            ./extras/gaming.nix
          ];
        };
        NOlaptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          config.allowUnfree = true;
          modules = [
            #   nixos-hw.common-cpu-intel
            #   # inputs.nixos-hardware.nixosModules.framework
            #   ./systems/BASED.nix
            #   ./systems/NOlaptop.nix
            #   ./users/tao.nix
            #   ./extras/uwuraid.nix
            #   ./extras/dev.nix
            #   ./extras/gaming.nix
          ];
        };
        # NOcomputer = nixos-system [
        #   ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
        #   nixos-hw.common-cpu-amd
        #   nixos-hw.common-gpu-nvidia-nonprime
        #   ./systems/BASED.nix
        #   ./systems/NOcomputer.nix
        #   # home-manager.nixosModules.home-manager
        #   ./users/tao.nix
        #   ./extras/uwuraid.nix
        #   ./extras/dev.nix
        #   ./extras/gaming.nix
        # ];
        # NOlaptop = nixos-system [
        #   ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
        #   nixos-hw.common-cpu-intel
        #   # inputs.nixos-hardware.nixosModules.framework
        #   ./systems/BASED.nix
        #   ./systems/NOlaptop.nix
        #   ./users/tao.nix
        #   ./extras/uwuraid.nix
        #   ./extras/dev.nix
        #   ./extras/gaming.nix
        # ];
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
