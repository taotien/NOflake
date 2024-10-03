{config, ...}: {
  age.secrets.uwuraid.file = ../secrets/uwuraid.age;
  # systemd.mounts = let
  #   opts = {
  #     type = "cifs";
  #     mountConfig = {Options = "x-systemd.automount,users,noauto,credentials=${config.age.secrets.uwuraid.path},noatime,uid=1000,gid=100";};
  #   };
  # in [
  #   (opts
  #     // {
  #       what = "//100.97.47.81/anime";
  #       where = "/mnt/uwuraid/anime";
  #     })
  #   # (opts
  #   #   // {
  #   #     what = "//100.97.47.81/appdata";
  #   #     where = "/mnt/uwuraid/appdata";
  #   #   })
  #   (opts
  #     // {
  #       what = "//100.97.47.81/backup";
  #       where = "/mnt/uwuraid/backup";
  #     })
  #   (opts
  #     // {
  #       what = "//100.97.47.81/everything";
  #       where = "/mnt/uwuraid/everything";
  #     })
  #   (opts
  #     // {
  #       what = "//100.97.47.81/games";
  #       where = "/mnt/uwuraid/games";
  #     })
  #   # (opts
  #   #   // {
  #   #     what = "//100.97.47.81/isos";
  #   #     where = "/mnt/uwuraid/isos";
  #   #   })
  #   # (opts
  #   #   // {
  #   #     what = "//100.97.47.81/jellyfin";
  #   #     where = "/mnt/uwuraid/jellyfin";
  #   #   })
  #   (opts
  #     // {
  #       what = "//100.97.47.81/movies";
  #       where = "/mnt/uwuraid/movies";
  #     })
  #   (opts
  #     // {
  #       what = "//100.97.47.81/music";
  #       where = "/mnt/uwuraid/music";
  #     })
  #   (opts
  #     // {
  #       what = "//100.97.47.81/photos";
  #       where = "/mnt/uwuraid/photos";
  #     })
  #   (opts
  #     // {
  #       what = "//100.97.47.81/syncthing";
  #       where = "/mnt/uwuraid/syncthing";
  #     })
  #   # (opts
  #   #   // {
  #   #     what = "//100.97.47.81/television";
  #   #     where = "/mnt/uwuraid/television";
  #   #   })
  #   (opts
  #     // {
  #       what = "//100.97.47.81/virginia";
  #       where = "/mnt/uwuraid/virginia";
  #     })
  # ];
  # systemd.automounts = let
  #   opts = {
  #     wantedBy = ["multi-user.target"];
  #     automountConfig = {TimeoutIdleSec = "60";};
  #   };
  # in [
  #   (opts // {where = "/mnt/uwuraid/anime";})
  #   # (opts // {where = "/mnt/uwuraid/appdata";})
  #   (opts // {where = "/mnt/uwuraid/backup";})
  #   (opts // {where = "/mnt/uwuraid/everything";})
  #   (opts // {where = "/mnt/uwuraid/games";})
  #   # (opts // {where = "/mnt/uwuraid/isos";})
  #   # (opts // { where = "/mnt/uwuraid/jellyfin"; })
  #   (opts // {where = "/mnt/uwuraid/movies";})
  #   (opts // {where = "/mnt/uwuraid/music";})
  #   (opts // {where = "/mnt/uwuraid/photos";})
  #   (opts // {where = "/mnt/uwuraid/syncthing";})
  #   (opts // {where = "/mnt/uwuraid/virginia";})
  #   # (opts // {where = "/mnt/uwuraid/television";})
  # ];
}
