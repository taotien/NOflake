def "config stuff" [] {
  hx ~/projects/NOflake/users/tao/nushell/stuff.nu
}

def fixme [] {
  rg FIXME --json
    | lines
    | each {from json}
    | where type == "match"
    | get data
    | flatten
    | each {$"($in.text):($in.line_number)"}
    | hx ...$in
}

source ~/.zoxide.nu
def --env z [path: string = "~"] {
  zo $path
  l
}

def "snapper list" [] {
  snapper --csvout list | from csv | reject config subvolume default user used-space userdata active
} 

def "snapper clear" [] {
  let list = snapper --csvout list | from csv | reject config subvolume default user used-space userdata active | skip 1

  let first = $list | first
  let last = $list | last

  snapper delete $"($first.number)-($last.number)"
}
