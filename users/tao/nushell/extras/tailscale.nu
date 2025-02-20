def check-mullvad [] {
  loop {
    print "checking connection status"
    http get https://am.i.mullvad.net/json 
      | if $in.mullvad_exit_ip == true {break} else {print $in}
    sleep 1sec
  }
}
def tse [exit_node: string = ""] {
  if ($exit_node | is-empty) and (ps | find deluge | is-not-empty) {
    return "stop summoning first!"
  } else {
    tailscale set --exit-node $exit_node
  }
  if ($exit_node | is-not-empty) {
    check-mullvad
  }
  return "exit node set"
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
  check-mullvad
}
alias ts = tailscale
alias tss = tailscale status
alias tsu = tailscale up
alias tsd = tailscale down
alias tsx = tailscale exit-node list
alias tsa = tailscale exit-node suggest

