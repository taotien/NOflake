{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    openrgb
    gwe
  ];

  fileSystems."/" = { options = [ "noatime" "compress-force=zstd:3" ]; };
  fileSystems."/var" = { options = [ "noatime" "compress-force=zstd:3" ]; };
  fileSystems."/tmp" = { options = [ "noatime" ]; };
  fileSystems."/home" = { options = [ "noatime" "compress-force=zstd:3" ]; };
  fileSystems."/home/tao/Games" = { options = [ "nosuid" "nodev" "noatime" "compress-force=zstd:3" "users" "rw" "exec" ]; };

  services.udev.packages = [ pkgs.openrgb ];
  services.udev.extraRules = ''
    SUBSYSTEM=="tty", GROUP="dialout", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
    SUBSYSTEM=="tty", GROUP="dialout", ATTRS{interface}=="Black Magic UART Port", SYMLINK+="ttyBmpTarg"
  '';

  boot.kernelModules = [ "i2c-dev" ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  networking.hostname = "NOcomputer";
}
