{lib, ...}: {
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            start = "1M";
            end = "128M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              mountpoint = "/";
              mountOptions = ["noatime" "compress-force=zstd:3" "discard=async"];
              subvolumes = {
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = ["noatime" "compress-force=zstd:3" "discard=async"];
                };
              };
            };
          };
        };
      };
    };
  };
}
