source ~/.cache/starship/init.nu
source ~/.zoxide.nu
alias b = btm;
alias cringe = sudo bootctl set-oneshot auto-windows
alias fetch = neofetch
alias ff = firefox
alias gc = sudo nix-collect-garbage -d
alias js = jj status
alias jd = jj diff
alias pu = pueue
alias rb = sudo nice -n19 nixos-rebuild boot --flake . --impure
alias rs = sudo nice -n19 nixos-rebuild switch --flake . --impure
alias t = task
alias ts = tailscale
alias tss = tailscale status
alias tsx = tailscale exit-node list
alias zl = zellij
task
