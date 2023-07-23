{ ... }: {
  services.rpcbind.enable = true;
  systemd.mounts = let commonMountOptions = { type = "nfs"; mountConfig = { Options = "noatime"; }; }; in
    [
      (commonMountOptions // { what = "100.86.160.104:/mnt/user/anime"; where = "/mnt/uwuraid/anime"; })
      (commonMountOptions // { what = "100.86.160.104:/mnt/user/backup"; where = "/mnt/uwuraid/backup"; })
      (commonMountOptions // { what = "100.86.160.104:/mnt/user/everything"; where = "/mnt/uwuraid/everything"; })
      (commonMountOptions // { what = "100.86.160.104:/mnt/user/movies"; where = "/mnt/uwuraid/movies"; })
      (commonMountOptions // { what = "100.86.160.104:/mnt/user/photos"; where = "/mnt/uwuraid/photos"; })
      (commonMountOptions // { what = "100.86.160.104:/mnt/user/syncthing"; where = "/mnt/uwuraid/syncthing"; })
      (commonMountOptions // { what = "100.86.160.104:/mnt/user/television"; where = "/mnt/uwuraid/television"; })
    ];
  systemd.automounts = let commonAutoMountOptions = { wantedBy = [ "multi-user.target" ]; automountConfig = { TimeoutIdleSec = "60"; }; }; in
    [
      (commonAutoMountOptions // { where = "/mnt/uwuraid/anime"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/backup"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/everything"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/movies"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/photos"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/syncthing"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/television"; })
    ];
}
