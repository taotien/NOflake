alias nd = nix develop

def ns [...packages: string] {
  let packages = $packages | each {$"nixpkgs#($in)"}
  nix shell ...$packages
}

# def nr [package] {
#   nix search nixpkgs $package
# }

def --wrapped rebuild [--force, subcommand,  ...rest] {
  if not (
    df -h | detect columns --guess | where "Mounted on" == "/" or "Mounted on" == "/boot" | get Use% | each {parse "{usage}%" | get usage | into int} | flatten | all {$in < 99}
  ) and not $force {
    print "not enough disk space!"
    return false
  }
  
  mut builders = ""
  if (open /etc/hostname --raw) == "NOlaptop\n" and ($builders != "") {
    if (ping -c1 -W1 nocomputer | complete | $in.exit_code == 0) {
       sudo nix store info --store ssh://nocomputer
    } else {
      $builders = ""
    }
  }

  sudo systemd-inhibit nice -n19 nixos-rebuild $subcommand --flake . --accept-flake-config --impure --verbose ...$rest o+e>| nom

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
  mut r = "@"
  loop {
    match (jj log -r $r --no-pager --no-graph --template 'if(empty, "empty", self.description())') {
      "bump (unbuilt)" | "bump (failed)" => {
        jj desc -m "bump (unbuilt)"
      }
      "empty" => {
        $r = $r + "-"
        continue 
      }
      _ => {
        jj new -r $r -m "bump (unbuilt)"
      }
    }
    break
  }
  let r = jj log -r @ --no-pager --no-graph --template 'change_id'
  sudo nix flake update
  if (rebuild boot) {
    jj desc -r $r -m $"bump (date now | format date "%Y-%m-%d")"
    jj bookmark set main -r $r
    jj git push
  } else {
    jj desc -r $r -m "bump (failed)"
  }
  jj new
  nvd history
}

alias rb = rebuild boot
alias rs = rebuild switch
alias gc = nh clean all

