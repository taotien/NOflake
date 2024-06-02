{
  config,
  inputs,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    bat
    bottom
    cifs-utils
    du-dust
    exfatprogs
    fastfetch
    git
    helix
    inputs.agenix.packages.${pkgs.system}.default
    ouch
    pueue
    ripgrep
    rustdesk
    skim
    tree
    # wezterm
    wget
    zstd
    zellij
  ];

  services.openssh.enable = true;
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.resolved.enable = true;

  security.sudo-rs.enable = true;
  security.sudo.enable = false;
  users.users.mc = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.nushell;
  };

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "bat";
    SKIM_DEFAULT_COMMAND = "rg --files";
  };

  time.timeZone = lib.mkDefault "US/Pacific";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.loader.timeout = lib.mkForce 1;
  boot.supportedFilesystems = ["btrfs"];
  boot.initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.kernelModules = ["kvm-intel"];

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = ["root" "@wheel"];
  };
  nixpkgs.config = {allowUnfree = true;};

  networking.hostName = "NOserver-minecraft";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = lib.mkDefault "23.05";
}
