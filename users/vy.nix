{pkgs, ...}: {
  users.users.vy.packages = with pkgs; [
  ];

  users.users.vy = {
    isNormalUser = true;
    extraGroups = ["scanner" "lp"];
  };
}
