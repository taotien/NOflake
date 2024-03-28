{pkgs, ...}: {
  # { pkgs, aagl, ... }: {
  # imports = [ aagl.nixosModules.default ];
  # nix.settings = aagl.nixConfig;
  # programs.honkers-railway-launcher.enable = true;
  # nixpkgs.config.permittedInsecurePackages = [
  #   "electron-24.8.6"
  #   # "electron-12.2.3"
  # ];

  environment.systemPackages = with pkgs; [
    # parsec-bin
    gamemode
    heroic
    lutris
    mangohud
    prismlauncher
    protonup-qt
    wine
    # yuzu # nintendo can suck the shit out of my asshole
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = false;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  security.pam.loginLimits = [
    {
      domain = "@game";
      type = "-";
      item = "nice";
      value = -20;
    }
  ];
  security.sudo-rs.extraRules = [
    {
      commands = [
        {
          command = "${pkgs.systemd}/bin/bootctl set-oneshot auto-windows";
          options = ["NOPASSWD"];
        }
      ];
      groups = ["wheel"];
    }
  ];
}
