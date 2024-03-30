let
  NOlaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFACYTHNr0dgtTe8cb6q+NwI1KaKJmNsUrnz5/8ZDvH";
  NOmom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGdPvIo0P00I27i9XQFngsklw/dSyoFs7EgRt7RvkbSq";
  systems = [NOlaptop NOmom];
in {
  "uwuraid.age".publicKeys = systems;
  "syncthing-NOcomputer.age".publicKeys = systems;
  "syncthing-NOlaptop.age".publicKeys = systems;
}
