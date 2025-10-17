def "config stuff" [] {
  hx ~/projects/NOflake/users/tao/nushell/stuff.nu
}

def fixme [] {
  let items = rg "FIXME|TODO" --json
    | lines
    | each {from json}
    | where type == "match"
    | get data
    | flatten
    | reject absolute_offset submatches
    | each {
      mut row = $in
      $row.lines_text = ($row.lines_text | str trim)
      $row
    }
    | sort
  let sel = $items.lines_text | input list -fi
  hx ($items | get $sel | $"($in.text):($in.line_number)")
}

source ~/.zoxide.nu
def --wrapped --env z [...rest] {
  zo ...$rest
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

def "fans" [duty?: int] {
  match (hostname) {
    "NOcomputer" => {
      let mode_path: path = (glob "/sys/devices/platform/nct6775.656/hwmon/hwmon*/pwm2_enable" | get 0)
      match $duty {
        100 => { sudo -- nu -c $"0 o> ($mode_path)" }
        _ => { sudo -- nu -c $"5 o> ($mode_path)" }
      }
    }
    "NOlaptop" => {
      match $duty {
        null => { sudo ectool autofanctrl }
        _ => { sudo ectool fanduty $duty }
      }
    }
  }
}

alias "fans max" = fans 100
alias "fans quiet" = fans 42

def asciicam [] {
  $env.DISPLAY = null
  mpv -vo caca av://v4l2:/dev/video0 --demuxer-lavf-o=input_format=mjpeg --profile=low-latency e>| /dev/null
}

def sunu [command] {
  sudo nu --stdin --commands $command
}
