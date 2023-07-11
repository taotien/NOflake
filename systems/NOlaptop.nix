{ ... }: {
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "nvme.noacpi=1"
  ];
}
