export def done [] {
  toastify send -a "" done
}

export def fixme [] {
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

export def "snapper list" [] {
  snapper --csvout list | from csv | reject config subvolume default user used-space userdata active
}

export def "snapper clear" [] {
  let list = snapper --csvout list | from csv | reject config subvolume default user used-space userdata active | skip 1

  let first = $list | first
  let last = $list | last

  if $first != $last {
    snapper delete $"($first.number)-($last.number)"
  } else {
    snapper delete $first
  }
}

export def "fans" [duty?: int] {
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

export alias louder = fans 100
export alias loud = fans
export alias quiet = fans 42

export def asciicam [] {
  $env.DISPLAY = null
  mpv -vo caca av://v4l2:/dev/video0 --demuxer-lavf-o=input_format=mjpeg --profile=low-latency e>| /dev/null
}

export def sunu [command] {
  sudo nu --stdin --commands $command
}
