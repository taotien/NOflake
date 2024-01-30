{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bat
    bottom
    cifs-utils
    git
    helix
    ouch
    ripgrep
    skim
    tree
    wget
  ];

  programs.partition-manager.enable = false;
  services.flatpak.enable = false;
  services.printing.enable = false;
  hardware.bluetooth.enable = false;
  services.xserver.enable = false;
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.desktopManager.plasma5.enable = false;
  services.pipewire.enable = false;

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
    SKIM_DEFAULT_COMMAND = "rg --files";
  };

  environment.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    SKIM_DEFAULT_COMMAND = "rg --files";
  };

