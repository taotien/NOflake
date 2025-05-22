{
    description = "we say NO to shitty OSes";

    inputs = {
        nixos.url = "github:NixOS/nixpkgs/nixos-24.05";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
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
        # helix = {
        #   url = "github:mattwparas/helix/steel-event-system";
        #   inputs.nixpkgs.follows = "nixpkgs";
        # };
        nixos-cosmic = {
            url = "github:lilyinstarlight/nixos-cosmic";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };
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
        nixos,
        self,
        nixpkgs,
        nixos-facter-modules,
        nixos-hardware,
        determinate,
        agenix,
        disko,
        home-manager,
        nixos-cosmic,
        zen-browser,
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
            NObangers = nixpkgs.lib.nixosSystem {
                system = "aarch64-linux";
                specialArgs = {inherit inputs;};
                modules = [
                    nixos-hardware.nixosModules.raspberry-pi-4
                    ./systems/BASED.nix
                    ./systems/NObangers.nix
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
                    # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
                    "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
                    ({
                        lib,
                        pkgs,
                        ...
                    }: {
                        nixpkgs.config = {
                            allowUnfree = true;
                        };
                        environment.systemPackages = with pkgs; [
                            helix
                            bat
                            bottom
                            dumbpipe
                            sendme
                            git
                            firefox
                            ouch
                            pueue
                            ripgrep
                            # rustdesk
                            skim
                            tree
                            wezterm
                            wget
                            zstd
                            # bcachefs-tools
                        ];
                        # boot.supportedFilesystems = ["bcachefs"];
                        boot.supportedFilesystems.btrfs = true;
                        boot.supportedFilesystems.zfs = lib.mkForce false;
                        boot.kernelPackages = pkgs.linuxPackages_latest;
                        isoImage.squashfsCompression = "zstd";
                    })
                ];
            };
        };
    };
}
