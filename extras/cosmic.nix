{pkgs, ...}: {
  services.desktopManager.plasma6.enable = false;
  services.displayManager.sddm.enable = false;

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-player
    cosmic-term
    cosmic-wallpapers
  ];
}
