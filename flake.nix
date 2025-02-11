{
  description = "we say NO to shitty OSes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    nixos-hardware.url = "nixos-hardware/master";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # plasma-manager = {
    #   url = "github:pjones/plasma-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    helix = {
      url = "github:mattwparas/helix/steel-event-system";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # prescurve.url = "github:taotien/prescurve";
    # prescurve.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    nixos.url = "nixpkgs/nixos-24.05";
  };

  nixConfig = {
    extra-substituters = [
      "https://cosmic.cachix.org/"
      # "https://helix.cachix.org/"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      # "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    nixos-facter-modules,
    nixos-hardware,
    agenix,
    disko,
    home-manager,
    # plasma-manager,
    nixos-cosmic,
    zen-browser,
    determinate,
    nixos,
    ...
  } @ inputs: {
    nixosConfigurations = {
      NOcomputer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          # nixos-hardware.common.gpu.nvidia.ampere
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./systems/BASED.nix
          ./systems/NOcomputer.nix
          ./users/tao.nix
          ./extras/uwuraid.nix
          ./extras/dev.nix
          ./extras/gaming.nix
          ./extras/folding.nix
          nixos-cosmic.nixosModules.default
          ./extras/cosmic.nix
        ];
      };
      NOlaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          ./systems/disk-config.nix
          nixos-hardware.nixosModules.framework-16-7040-amd
          # nixos-facter-modules.nixosModules.facter
          # {
          #   config.facter.reportPath =
          #     if builtins.pathExists ./systems/NOlaptop-facter.json
          #     then ./systems/NOlaptop-facter.json
          #     else throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
          # }
          agenix.nixosModules.default
          determinate.nixosModules.default
          home-manager.nixosModules.home-manager
          ./systems/BASED.nix
          ./systems/NOlaptop.nix
          ./users/tao.nix
          ./extras/uwuraid.nix
          ./extras/dev.nix
          ./extras/gaming.nix
          nixos-cosmic.nixosModules.default
          ./extras/cosmic.nix
        ];
      };
      NOmom = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.common-cpu-intel
          # inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./systems/BASED.nix
          ./systems/NOmom.nix
          ./users/tao.nix
          ./users/vy.nix
          ./extras/uwuraid.nix
        ];
      };
      NOserver-minecraft = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          agenix.nixosModules.default
          disko.nixosModules.disko
          {disko.devices.disk.disk1.device = "/dev/vda";}
          ./systems/NOserver.nix
          ./extras/NOserver-disk-config.nix
          ./extras/minecraft-server.nix
        ];
      };
      bcachefs-iso = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
          ({
            lib,
            pkgs,
            ...
          }: {
            boot.supportedFilesystems = ["bcachefs"];
            boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
          })
        ];
      };
    };
  };
}
