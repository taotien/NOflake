# task

def h [query?: path] {
  (if ($query != null) {sk -1 -q ($query | path basename)} else {sk -1}) 
  | complete
  | if $in.exit_code == 0 {
      $in.stdout | str trim | hx $in
    }
}

def --env c [path: path = "~"] {
  cd $path
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

def srg [] {
  sk --ansi -i -c 'rg --color=always --line-number "{}"'
}


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
# source ~/.cache/carapace/init.nu
source ~/.zoxide.nu
def --env z [path: string = "~"] {
  zo $path
  l
}
