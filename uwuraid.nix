{ ... }: {
  services.rpcbind.enable = true;
  systemd.mounts = let commonMountOptions = { type = "nfs"; mountConfig = { Options = "noatime"; }; }; in
    [
      (commonMountOptions // { what = "192.168.86.56:/mnt/user/anime"; where = "/mnt/uwuraid/anime"; })
      (commonMountOptions // { what = "192.168.86.56:/mnt/user/backup"; where = "/mnt/uwuraid/backup"; })
      (commonMountOptions // { what = "192.168.86.56:/mnt/user/syncthing"; where = "/mnt/uwuraid/syncthing"; })
      (commonMountOptions // { what = "192.168.86.56:/mnt/user/television"; where = "/mnt/uwuraid/television"; })
      (commonMountOptions // { what = "192.168.86.56:/mnt/user/photos"; where = "/mnt/uwuraid/photos"; })
      (commonMountOptions // { what = "192.168.86.56:/mnt/user/movies"; where = "/mnt/uwuraid/movies"; })
    ];
  systemd.automounts = let commonAutoMountOptions = { wantedBy = [ "multi-user.target" ]; automountConfig = { TimeoutIdleSec = "60"; }; }; in
    [
      (commonAutoMountOptions // { where = "/mnt/uwuraid/anime"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/backup"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/syncthing"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/television"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/photos"; })
      (commonAutoMountOptions // { where = "/mnt/uwuraid/movies"; })
    ];
}
