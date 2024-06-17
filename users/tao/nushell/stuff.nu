task 

alias b = btm
alias cringe = sudo bootctl set-oneshot auto-windows
alias fetch = fastfetch
alias ff = firefox
alias pu = pueue
alias t = task
alias zl = zellij
alias snapper = snapper -c home

alias jd = jj diff
alias jc = jj desc
alias js = jj status
alias jp = jj git push
alias jm = jj branch set main

def c [path: path = "~"] {
  export-env {cd $path}
  l
}
def l [
  --all (-a)
  --long (-l)
  path: path = "."
] {
  if $all and $long {
    ls -la $path
  } else if $all {
    ls -a $path
  } else if $long {
    ls -l $path
  } else {
    ls $path
  }
  | sort-by type name -i -n
}

def srg [pattern] {
  sk --ansi -i -c 'rg --color=always --line-number "{}"'
}

alias nd = nix develop
def ns [package] {
  nix shell $"nixpkgs#($package)"
}
def nr [package] {
  nix search nixpkgs $package
}

def rebuild [subcommand] {
    sudo nice -n19 nixos-rebuild $subcommand --flake /home/tao/projects/NOflake/ --impure --verbose
}
# def post-rebuild [] {
#     # rm -r ~/.config/helix/runtime/grammars/
#     # hx --grammar fetch; hx --grammar build
#     # rustup update
# }
def bump [] {
  cd /home/tao/projects/NOflake/
  jj new -m "bump"
  nix flake update
  # rc2nix | save -f /home/tao/projects/NOflake/users/tao/plasma.nix;
  # sudo nix store ping --store ssh://nocomputer
  rebuild boot
  jj new
}
alias rb = rebuild boot
alias rs = rebuild switch
alias gc = nh clean all


def tse [exit_node: string = ""] {
  if ($exit_node | is-empty) and (ps | find deluge | is-not-empty) {
    print "stop summoning first!"
    return
  } else {
    tailscale set --exit-node $exit_node
  }
  http get https://am.i.mullvad.net/json
}
def tsp [] {
  tailscale exit-node list
    | split row "\n"
    | each {str trim}
    | filter {is-not-empty}
    | skip 1
    | last 19
    | first 17
    | split column -r '\s{2,}'
    | reject column5 column3
    | rename ip addr city
    | par-each {
      insert ping {
        |row| $row.addr
          | str replace "mullvad.ts.net" "relays.mullvad.net"
          | ping -c5 -q $in
          | split row "\n"
          | last
          | split column "/"
          | get column6?
          | get 0
        }
      }
    | sort-by ping -n -r
 }
def tsr [] {
  tailscale status --json
    | from json
    | get Peer
    | transpose nodekey node
    | get node
    | filter {$in.Location?.Country == USA}
    | get TailscaleIPs
    | each {get 0}
    | select (random int 0..($in | length))
    | tse $in.0
  # tailscale status
  http get https://am.i.mullvad.net/json
}
alias ts = tailscale
alias tss = tailscale status
alias tsu = tailscale up
alias tsd = tailscale down
alias tsx = tailscale exit-node list
alias tsa = tailscale exit-node suggest

def "config stuff" [] {
  hx ~/projects/NOflake/users/tao/nushell/stuff.nu
}

def deluge-gtk [] {
  tsr
  deluge-gtk
}
alias deluge = deluge-gtk

def fixme [] {
  rg TODO --json
    | lines
    | each {from json}
    | where type == "match"
    | get data
    | flatten
    | each {$"($in.text):($in.line_number)"}
    | hx ...$in
}

source ~/.cache/starship/init.nu
source ~/.zoxide.nu
