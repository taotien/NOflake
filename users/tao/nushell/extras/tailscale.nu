# see if others see us connecting from a mullvad exit node
export def check-mullvad [] {
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
export def te [exit_node: string = ""] {
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
export def tx [] {
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
export def tsp [] {
tx
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
export def tr [] {
  tx
    | get (random int 0..($in | length))
    | te $in.IP
    | return $in
}

export alias t = tailscale
export alias ts = tailscale status
export alias tu = tailscale up
export alias td = tailscale down
export alias ta = tailscale exit-node suggest
export alias tt = tailscale switch --list | detect columns | input list -d Tailnet | get ID | t switch $in

export alias wno = ssh root@whyfi "etherwake -i br-lan 04:42:1A:E7:62:C3"
