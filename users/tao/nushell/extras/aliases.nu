export alias b = btm
export alias d = dirs
export alias da = dirs add
export alias dg = dirs goto
export alias dn = dirs next
export alias dp = dirs prev
export alias dr = dirs drop
export alias fetch = fastfetch
export alias follow = readlink -f
export alias p = pueue
export alias snapper = snapper -c home
export alias zl = zellij
export alias wssh = wezterm ssh

export def today-iso [] { date now | format date %F }

export alias cringe = sudo bootctl set-oneshot auto-windows

export alias la = ls -a
export alias ll = ls -l
export alias lla = ls -la

export def --env c [path: path = "~"] {
  cd $path
  l
}

export def l --wrapped [path: path = ".", ...rest] {
  ls -t $path ...$rest | insert ext {|row| $row.name | parse "{name}.{ext}" | get ext | get 0? } | sort-by --natural type ext name | reject type ext
}

export def h [query?: path] {
  (if ($query != null) {sk -1 -q ($query | path basename)} else {sk -1})
  | if ($in != "") {
    hx $in
  }
  # | complete
  # | if $in.exit_code == 0 {
  #     $in.stdout | str trim | hx $in
  #   }
}

export def srg [] {
  sk --ansi -i -c 'rg --color=always --line-number "{}"'
}

export alias j = jj
export alias ja = jj log -r 'all()'
export alias jc = jj desc
export alias jd = jj diff
export alias je = jj edit
export alias jf = jj git fetch
export alias jg = jj git clone --colocate
export alias jp = jj git push
export alias js = jj status
export alias jw = jj workspace update-stale
export alias jt = jj log -r @ -T `description`
export alias jn = jj next --edit

export def jm --wrapped [-r: string = "@", ...rest] {
  mut r = $r
  if (jj log -r @ --no-pager --no-graph --template 'if(empty,"empty")' | $in == "empty") {
    $r = "@-"
  }
  jj bookmark set main -r $r ...$rest
  jj git push
}

export alias list-automounts = systemctl list-units --type=automount

export def remount [] {
  let reload = list-automounts | detect columns --guess  | drop 5 | get DESCRIPTION | input list --multi
  for mount in $reload {
    sudo systemctl restart $mount
  }
}

export def cpedit [file: path] {
  mv $file $"($file).sym"; cp $"($file).sym" $file; chmod +w $file
}

export alias core-job = job
export alias job = job list

export alias mpv-hdr-dv = mpv --target-trc=pq --target-prim=bt.2020 --target-peak=800
