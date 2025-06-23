{config, ...}: {
    age.secrets.uwuraid.file = ../secrets/uwuraid.age;
    systemd.mounts = let
        opts = {
            type = "cifs";
            mountConfig = {Options = "noauto,noatime,async,users,rw,x-systemd.automount,credentials=${config.age.secrets.uwuraid.path},gid=users,file_mode=0770,dir_mode=0770";};
        };
    in [
        (opts
        // {
            what = "//100.97.47.81/backup";
            where = "/mnt/uwuraid/backup";
        })
        (opts
        // {
            what = "//100.97.47.81/everything";
            where = "/mnt/uwuraid/everything";
        })
        (opts
        // {
            what = "//100.97.47.81/downloads";
            where = "/mnt/uwuraid/downloads";
        })
        (opts
        // {
            what = "//100.97.47.81/media";
            where = "/mnt/uwuraid/media";
        })
        # (opts
        #   // {
        #     what = "//100.97.47.81/isos";
        #     where = "/mnt/uwuraid/isos";
        #   })
        (opts
        // {
            what = "//100.97.47.81/photos";
            where = "/mnt/uwuraid/photos";
        })
        (opts
        // {
            what = "//100.97.47.81/virginia";
            where = "/mnt/uwuraid/virginia";
        })
    ];
    systemd.automounts = let
        opts = {
            wantedBy = ["multi-user.target"];
            automountConfig = {
                TimeoutIdleSec = "60";
                # DirectoryMode
            };
        };
    in [
        (opts // {where = "/mnt/uwuraid/backup";})
        (opts // {where = "/mnt/uwuraid/everything";})
        (opts // {where = "/mnt/uwuraid/downloads";})
        (opts // {where = "/mnt/uwuraid/media";})
        # (opts // {where = "/mnt/uwuraid/isos";})
        (opts // {where = "/mnt/uwuraid/photos";})
        (opts // {where = "/mnt/uwuraid/virginia";})
    ];
}
