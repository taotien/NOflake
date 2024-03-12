{...}: {
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.displayManager.cosmic-greeter.enable = true;
  services.xserver.desktopManager.cosmic.enable = true;
}
