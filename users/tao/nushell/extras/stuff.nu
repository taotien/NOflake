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
