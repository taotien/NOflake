{ pkgs, ... }:
{
  users.users.tao.packages = with pkgs; [
    # expressvpn
    # fractal
    # gnumake
    # libftdi
    # libusb
    # nix-prefetch-scripts
    # pkg-config
    # aspell
    # aspellDicts.en
    # enchant
    # nuspell
    # hunspellDicts.en-us-large
    # rustdesk
    # bottles
    # cider
    # darktable
    # deluge
    # discord
    # gh
    # keepassxc
    # libsForQt5.kcharselect
    libsForQt5.kdeconnect-kde
    # mdbook
    # partition-manager
    # slack
    # tectonic
    # texlab
    # tio
    # unstable.typst
    # ocs-url
    # typst-lsp
    # unstable.nushell
    # unstable.prusa-slicer
    # unstable.starship
    # unstable.wezterm
    # virt-manager
    # zoom-us
    # zoxide
    # obs-studio
  ];
  # programs.nushell.enable = true;
  # environment.shells = with pkgs; [ unstable.nushell ];

  # services.expressvpn.enable = true;

  # virtualisation.libvirtd.enable = true;
  # programs.dconf.enable = true;

  # services.syncthing = {
  #   enable = true;
  #   user = "tao";
  #   dataDir = "/home/tao/Sync";
  #   configDir = "/home/tao/.config/syncthing";
  # };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  users.users.tao = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "dialout" "scanner" "lp" ];
    # shell = pkgs.unstable.nushell;
  };

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-chewing fcitx5-chinese-addons fcitx5-rime ];
  # };
}
