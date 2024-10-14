{lib, ...}: {
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/disk/by-diskseq/1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          plainSwap = {
            size = "32G";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "filesystem";
              format = "bcachefs";
              mountOptions = ["noatime"];
              mountpoint = "/";
              extraArgs = [
                "--compression zstd"
                "--background_compression zstd"
                "--discard"
              ];
              # subvolumes = {
              #   "/home" = {};
              #   "/nix" = {};
              # };
            };
          };
        };
      };
    };
  };
}
