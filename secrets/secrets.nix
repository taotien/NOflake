let
  # get these from /etc/ssh
  NOcomputer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPv53GM1uDDOdRxIlHmpf6x2y13yT5bFDNyrgDGLAR1l";
  NOlaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtdTREsBxzg/8s0lVCwL+r18qMP8glxAKaKEg+71I6m";
  NOmom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGdPvIo0P00I27i9XQFngsklw/dSyoFs7EgRt7RvkbSq";
  systems = [NOcomputer NOlaptop NOmom];
in {
  "uwuraid.age".publicKeys = systems;
  "syncthing-NOcomputer.age".publicKeys = systems;
  "syncthing-NOlaptop.age".publicKeys = systems;
  "syncthing-uwuraid.age".publicKeys = systems;
  "password-tao.age".publicKeys = systems;
}
