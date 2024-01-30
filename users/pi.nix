{ pkgs, ... }:
{
  users.users.tao.packages = with pkgs; [
    libsForQt5.kdeconnect-kde
  ];
  # programs.nushell.enable = true;
  # environment.shells = with pkgs; [ nushell ];

  # services.expressvpn.enable = true;

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
    extraGroups = [ "wheel" "dialout" ];
    # shell = pkgs.nushell;
  };

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-chewing fcitx5-chinese-addons fcitx5-rime ];
  # };
}
