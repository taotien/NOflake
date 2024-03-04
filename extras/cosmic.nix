{...}: {
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.cosmic-greeter.enable = false;
  services.xserver.desktopManager.cosmic.enable = true;
}
