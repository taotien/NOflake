{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    arduino
    firefox
    qgis-ltr
    qgroundcontrol
  ];

  networking.hostName = "NObcer";
  users.users.ssrov = {
    isNormalUser = true;
    extraGroups = [ "dialout" ];
    hashedPassword = "";
  };
}
