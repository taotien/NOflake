# see if others see us connecting from a mullvad exit node
def check-mullvad [] {
  print -n "checking mullvad status"
  mut check = false
  mut j = null
  while not $check {
    print -n "."
    $j = (http get https://am.i.mullvad.net/json)
    $check = $j.mullvad_exit_ip
  }
  print ""
  return $"connected to ($j.city), ($j.country)"
}

# switch to a specific exit node, or none
def tse [exit_node: string = ""] {
  if ($exit_node | is-empty) and (ps | find deluge | is-not-empty) {
    print "stop summoning first!"
    return false
  }

  tailscale set --exit-node $exit_node

  if ($exit_node | is-not-empty) {
    check-mullvad
  } else {
    print "exit node set"
    return true 
  }
}

# list all mullvad exit nodes
def tsx [] {
tailscale exit-node list
  | lines
  | drop 4
  | skip 1
  | to text
  | detect columns --guess
  | where HOSTNAME =~ mullvad
  | reject STATUS
}

# sort mullvad exit nodes by fastest ping
def tsp [] {
tsx
  | where COUNTRY == USA
  | par-each {
    insert ping {
      $in.HOSTNAME
        | str replace "mullvad.ts.net" "relays.mullvad.net"
        | try {
          print $"pinging ($in)"
          ping -c5 -q $in
            | lines
            | last
            | split row ' '
            | get 3
            | split row '/'
            | get 1
            | into float
          }
      }
    }
  | sort-by ping
}

# switch to a random mullvad exit node
def tsr [] {
  tsx
    | get (random int 0..($in | length))
    | tse $in.IP
    | return $in
}

alias ts = tailscale
alias tss = tailscale status
alias tsu = tailscale up
alias tsd = tailscale down
alias tsa = tailscale exit-node suggest
