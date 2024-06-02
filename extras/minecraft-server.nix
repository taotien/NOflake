{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    temurin-jre-bin-17
  ];
  networking.firewall.allowedTCPPorts = [25565];
}
