let
  tao-NOlaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINimJXI8WOYUMwfAcGyKB9EYtuaClNjeEH4ZTQl9tuUY";
  users = [tao-NOlaptop];
in {
  "uwuraid.age".publicKeys = users;
  "syncthing-NOcomputer.age".publicKeys = users;
}
