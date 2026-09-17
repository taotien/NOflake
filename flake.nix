{
    description = "we say NO to shitty OSes";

    inputs = {
        nixos.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        # nixpkgs-last-building.url = "github:NixOS/nixpkgs/64c08a7ca051951c8eae34e3e3cb1e202fe36786";
        # Last nixpkgs commit before linux_6_17 was removed (EOL'd 2025-12-22).
        # Used only to source boot.kernelPackages for NOlaptop -- bcachefs's
        # out-of-tree module is broken on every currently-available kernel
        # branch below 6.16, and 6.17 is the best lead we have against the
        # amdgpu MES/gfxoff hang on the 780M iGPU that 6.18 doesn't fix.
        nixpkgs-kernel-pin.url = "github:NixOS/nixpkgs/52a3852da4f7";
        determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        agenix = {
            url = "github:ryantm/agenix";
            inputs.darwin.follows = "";
        };
        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        helix = {
            url = "github:helix-editor/helix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
        lsfg-vk-flake.inputs.nixpkgs.follows = "nixpkgs";
    };

    nixConfig = {
        extra-substituters = ["https://helix.cachix.org"];
        extra-trusted-public-keys = ["helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="];
    };

    outputs = {
        nixos,
        self,
        nixpkgs,
        nixpkgs-unstable,
        nur,
        nixos-facter-modules,
        nixos-hardware,
        determinate,
        agenix,
        disko,
        home-manager,
        zen-browser,
        lsfg-vk-flake,
        helix,
        ...
    } @ inputs: {
        templates = {
            devenv-ros = {
                path = ./templates/devenv/ros;
                description = "ROS2 + Rust + Python devenv.sh template (nix-ros-overlay based)";
            };
            default = self.templates.devenv-ros;
        };

        nixosConfigurations = {
            NOcomputer = nixpkgs.lib.nixosSystem {
                specialArgs = {inherit inputs;};
                modules = [
                    disko.nixosModules.disko
                    nixos-hardware.nixosModules.common-cpu-amd
                    nixos-hardware.nixosModules.common-cpu-amd-pstate
                    nixos-hardware.nixosModules.common-cpu-amd-zenpower
                    nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
                    agenix.nixosModules.default
                    home-manager.nixosModules.home-manager
                    ./systems/BASED.nix
                    ./systems/NOcomputer.nix
                    ./users/tao.nix
                    ./extras/uwuraid.nix
                    ./extras/dev.nix
                    ./extras/gaming.nix
                    lsfg-vk-flake.nixosModules.default
                    ./extras/folding.nix
                    ./users/builder.nix
                ];
            };
            NOlaptop = nixpkgs.lib.nixosSystem {
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
                    lsfg-vk-flake.nixosModules.default
                    nur.modules.nixos.default
                ];
            };
            NOmom = nixpkgs.lib.nixosSystem {
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
                specialArgs = {inherit inputs;};
                modules = [
                    nixos-hardware.nixosModules.raspberry-pi-4
                    ./systems/BASED.nix
                    ./systems/NObangers.nix
                    agenix.nixosModules.default
                    ./extras/uwuraid.nix
                ];
            };
            NOserver-minecraft = nixpkgs.lib.nixosSystem {
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
            # nix build .#nixosConfigurations.bcachefs-iso.config.system.build.isoImage
            bcachefs-iso = nixos.lib.nixosSystem {
                modules = [
                    {nixpkgs.hostPlatform = "x86_64-linux";}
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
                            # keep-sorted start
                            bat
                            # rustdesk
                            bcachefs-tools
                            bottom
                            disko
                            dumbpipe
                            firefox
                            git
                            helix
                            ouch
                            pueue
                            ripgrep
                            sendme
                            skim
                            tree
                            wezterm
                            wget
                            zstd
                            # keep-sorted end
                        ];
                        boot.supportedFilesystems.btrfs = true;
                        boot.supportedFilesystems.bcachefs = true;
                        boot.supportedFilesystems.zfs = lib.mkForce false;
                        boot.kernelPackages = pkgs.linuxPackages_latest;
                        isoImage.squashfsCompression = "zstd";
                    })
                ];
            };
        };
    };
}
