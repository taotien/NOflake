{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cosmic-term
    fontconfig
    freetype
    lld
    pkg-config
  ];

  # environment.variables = {
  #   PKG_CONFIG_PATH =
  #     };
}
