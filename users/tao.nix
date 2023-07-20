{ pkgs, ... }:
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
    # gnumake
    # pkg-config
    # libftdi
    # libusb
    keepassxc
    libsForQt5.kdeconnect-kde
    lldb
    # nix-prefetch-scripts
    starship
    tio
    partitionmanager
    unstable.nushell
    unstable.prusa-slicer
    unstable.wezterm
    virt-manager
    zoxide
  ];

  services.syncthing = {
    enable = true;
    user = "tao";
    dataDir = "/home/tao/Sync";
    configDir = "/home/tao/.config/syncthing";
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
