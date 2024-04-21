source ~/.cache/starship/init.nu
source ~/.zoxide.nu

def bump [] {
  cd /home/tao/projects/NOflake/;
  jj new -m "bump";
  nix flake update;
  # rc2nix | save -f /home/tao/projects/NOflake/users/tao/plasma.nix;
  sudo nixos-rebuild boot --flake /home/tao/projects/NOflake/ --impure --verbose;
};

def tse [exit_node] {
  tailscale set --exit-node="$exit_node"
}

alias b = btm;
alias cringe = sudo bootctl set-oneshot auto-windows
alias fetch = neofetch
alias ff = firefox
alias gc = sudo nix-collect-garbage -d
alias js = jj status
alias jd = jj diff
alias pu = pueue
alias rb = sudo nice -n19 nixos-rebuild boot --flake . --impure --verbose
alias rs = sudo nice -n19 nixos-rebuild switch --flake . --impure --verbose
alias t = task
alias ts = tailscale
alias tss = tailscale status
alias tsx = tailscale exit-node list
alias zl = zellij
task
