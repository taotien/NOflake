{ pkgs, ... }:
{
  users.users.tao.packages = with pkgs; [
    darktable
    deluge
    discord
    # fractal
    gh
    # gnumake
    # pkg-config
    # libftdi
    # libusb
    keepassxc
    libsForQt5.kdeconnect-kde
    # nix-prefetch-scripts
    unstable.starship
    tio
    partition-manager
    unstable.nushell
    unstable.prusa-slicer
    unstable.wezterm
    virt-manager
    zoxide
  ];

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

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
