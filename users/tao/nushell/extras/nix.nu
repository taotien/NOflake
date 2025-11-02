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
    sudo systemd-inhibit nice -n19 nixos-rebuild $subcommand --flake . --accept-flake-config --impure --verbose --builders "" o+e>| nom
  } else {
    sudo systemd-inhibit nice -n19 nixos-rebuild $subcommand --flake . --accept-flake-config --impure --verbose o+e>| nom
  }
  if $env.LAST_EXIT_CODE == 0 {
    toastify send "rebuild" "done!"
    return true
  } else {
    toastify send "rebuild" "failed!"
    return false
  }
}

def post-rebuild [] {
    rm -r ~/.config/helix/runtime/grammars/
    hx --grammar fetch; hx --grammar build
    rustup update
}

def bump [...rest] {
  cd /home/tao/projects/NOflake/
  match (jj log -r @ --no-pager --no-graph --template 'if(empty, "empty", self.description())') {
    "empty" => {
      jj desc -m "bump (unbuilt)"
    }
    "bump (unbuilt)" | "bump (failed)" => {}
  }
  sudo nix flake update
  # rc2nix | save -f /home/tao/projects/NOflake/users/tao/plasma.nix;
  if (rebuild boot) {
    jj desc -m $"bump (date now | format date "%Y-%m-%d")"
  } else {
    jj desc -m "bump (failed)"
  }
  jj new
}

alias rb = rebuild boot
alias rs = rebuild switch
alias gc = nh clean all

