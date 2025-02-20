alias nd = nix develop
def ns [package] {
  nix shell $"nixpkgs#($package)"
}
def nr [package] {
  nix search nixpkgs $package
}

def rebuild --wrapped [subcommand, --builders: string, ...rest] {
  if (open /etc/hostname --raw) == "NOlaptop\n" and ($builders != "") {
    sudo nix store info --store ssh://nocomputer
  }
  if ($builders == "") {
    sudo systemd-inhibit nice -n19 nixos-rebuild $subcommand --flake . --impure --verbose --builders ""
  } else {
    sudo systemd-inhibit nice -n19 nixos-rebuild $subcommand --flake . --impure --verbose ...$rest
  }
  toastify send rebuild done!
}
def post-rebuild [] {
    rm -r ~/.config/helix/runtime/grammars/
    hx --grammar fetch; hx --grammar build
    rustup update
}
def bump --wrapped [...rest] {
  cd /home/tao/projects/NOflake/
  jj new -m "bump"
  nix flake update
  # rc2nix | save -f /home/tao/projects/NOflake/users/tao/plasma.nix;
  # sudo nix store ping --store ssh://nocomputer
  rebuild boot ...$rest
  jj new
}
alias rb = rebuild boot
alias rs = rebuild switch
alias gc = nh clean all

