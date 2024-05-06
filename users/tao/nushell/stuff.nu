source ~/.cache/starship/init.nu
source ~/.zoxide.nu

def bump [] {
  cd /home/tao/projects/NOflake/
  jj new -m "bump"
  nix flake update
  # rc2nix | save -f /home/tao/projects/NOflake/users/tao/plasma.nix;
  sudo nixos-rebuild boot --flake /home/tao/projects/NOflake/ --impure --verbose
}

def l [
  path?
  flags?
] {
  if $path != null {
    ls $path
  } else {
    ls
  } | sort-by type name -i
}

def tse [exit_node?] {
  if $exit_node != null {
    tailscale set --exit-node $exit_node
  } else {
    tailscale set --exit-node=""
  }
}

def tsr [] {
  tailscale status --json | from json | get Peer | transpose nodekey node | get node | filter {$in.Location?.Country == USA} | get TailscaleIPs | each {get 0} | select (random int 0..($in | length)) | tse $in.0;
  tailscale status
}

def rb [] {
  sudo nice -n19 nixos-rebuild boot --flake . --impure --verbose
  hx --grammar fetch; hx --grammar build
  rm -rf ~/.cache/jdtls/
}

def rs [] {
  sudo nice -n19 nixos-rebuild switch --flake . --impure --verbose
  hx --grammar fetch; hx --grammar build
  rm -rf ~/.cache/jdtls/
}

def ns [package] {
  nix shell $"nixpkgs#($package)"
}


alias ard = arduino-cli
alias arduino-cli = boxxy arduino-cli
alias b = btm;
alias cringe = sudo bootctl set-oneshot auto-windows
alias fetch = neofetch
alias ff = firefox
alias gc = nh clean all
alias jd = jj diff
alias js = jj status
alias pu = pueue
alias t = task
alias ts = tailscale
alias tss = tailscale status
alias tsx = tailscale exit-node list
alias zl = zellij

task
