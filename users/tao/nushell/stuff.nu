task 

alias b = btm
alias cringe = sudo bootctl set-oneshot auto-windows
alias fetch = fastfetch
alias ff = firefox
alias jd = jj diff
alias js = jj status
alias pu = pueue
alias t = task
alias zl = zellij


def c [path: path = "~"] {
  cd $path
  l
}
def l [
  path: path = "."
] {
  ls $path
  | sort-by type name -i -n
}


def ns [package] {
  nix shell $"nixpkgs#($package)"
}
def rebuild [subcommand] {
    sudo nice -n19 nixos-rebuild $subcommand --flake /home/tao/projects/NOflake/ --impure --verbose
    hx --grammar fetch; hx --grammar build
    rm -rf ~/.cache/jdtls/
}
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
    tailscale set --exit-node $exit_node
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
    | sort-by ping -n
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
  tailscale status
  firefox https://mullvad.net/en/check
}
alias ts = tailscale
alias tss = tailscale status
alias tsu = tailscale up
alias tsd = tailscale down
alias tsx = tailscale exit-node list


source ~/.cache/starship/init.nu
source ~/.zoxide.nu
