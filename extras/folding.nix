{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # boinctui
  ];
  services.boinc = {
    enable = true;
  };

  # services.foldingathome = {
  #   enable = true;
  #   team = 223518;
  #   user = "Tao_Tien";
  #   extraArgs = ["--passkey=76ba03d55acf116776ba03d55acf1167"];
  # };
}
