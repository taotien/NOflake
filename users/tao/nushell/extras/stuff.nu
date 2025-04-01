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

const mode_path: path = "/sys/devices/platform/nct6775.656/hwmon/hwmon9/pwm2_enable"

def quiet [] {
  match (hostname) {
    "NOcomputer" => {sudo -- nu -c $"5 o> ($mode_path)"}
    "NOlaptop" => {
      sudo ectool fanduty 42      
    }
  }
}

def loud [] {
  match (hostname) {
    "NOcomputer" => {sudo -- nu -c $"5 o> ($mode_path)"}
    "NOlaptop" => {sudo ectool autofanctrl}
  }
}

def louder [] {
  match (hostname) {
    "NOcomputer" => {sudo -- nu -c $"0 o> ($mode_path)"}
    "NOlaptop" => {sudo ectool fanduty 100}
  }
}
