{ pkgs, config, ... }:
let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in
{
  users.users.tao.packages = with pkgs; [
    darktable
    deluge
    discord
    elf2uf2-rs
    # fractal
    gcc
    gh
    gdb
    keepassxc
    libsForQt5.kdeconnect-kde
    lldb
    # nix-prefetch-scripts
    starship
    tio
    unstable.nushell
    unstable.prusa-slicer
    virt-manager
    zoxide
  ];

  services.syncthing = {
    enable = true;
    user = "tao";
    dataDir = "/home/tao/Sync";
    configDir = "/home/tao/.config/syncthing";
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  users.users.tao = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "dialout" ];
  };
}
