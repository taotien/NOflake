alias nd = nix develop

def ns [...packages: string] {
  let packages = $packages | each {$"nixpkgs#($in)"}
  nix shell ...$packages
}

# def nr [package] {
#   nix search nixpkgs $package
# }

def rebuild [subcommand, --builders: string] {
  mut builders = $builders;
  if (open /etc/hostname --raw) == "NOlaptop\n" and ($builders != "") {
    if (ping -c1 -W1 nocomputer | complete | $in.exit_code == 0) {
       sudo nix store info --store ssh://nocomputer
    } else {
      $builders = ""
    }
  }
  if ($builders == "") {
    sudo systemd-inhibit nice -n19 nixos-rebuild $subcommand --flake . --impure --verbose --builders "" --log-format internal-json o+e>| nom --json
  } else {
    sudo systemd-inhibit nice -n19 nixos-rebuild $subcommand --flake . --impure --verbose --log-format internal-json o+e>| nom --json
  }
  toastify send rebuild done!
}

def post-rebuild [] {
    rm -r ~/.config/helix/runtime/grammars/
    hx --grammar fetch; hx --grammar build
    rustup update
}

def bump [...rest] {
  cd /home/tao/projects/NOflake/
  mut r = "@"
  if (jj log -r @ --no-pager --no-graph --template 'if(empty,"empty")' | $in == "empty") {
    $r = "@-"
  }
  jj new -m "bump" -r $r
  nix flake update
  # rc2nix | save -f /home/tao/projects/NOflake/users/tao/plasma.nix;
  # sudo nix store ping --store ssh://nocomputer
  rebuild boot
  jj new
}

alias rb = rebuild boot
alias rs = rebuild switch
alias gc = nh clean all

