{pkgs, ...}: {
  services.displayManager.sddm.enable = true;
  services.displayManager.cosmic-greeter.enable = false;
  services.desktopManager.cosmic.enable = true;

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-player
    cosmic-wallpapers
    cosmic-term
    cosmic-edit
  ];
}
