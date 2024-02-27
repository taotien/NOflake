{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cosmic-bg
    cosmic-applets
    cosmic-applibrary
    cosmic-comp
    cosmic-edit
    cosmic-files
    cosmic-greeter
    cosmic-icons
    cosmic-launcher
    cosmic-notifications
    cosmic-osd
    cosmic-panel
    cosmic-protocols
    cosmic-randr
    cosmic-screenshot
    cosmic-session
    cosmic-settings
    cosmic-settings-daemon
    cosmic-term
    cosmic-workspaces-epoch
    xdg-desktop-portal-cosmic
  ];
}
