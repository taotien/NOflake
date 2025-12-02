alias b = btm
alias d = dirs
alias da = dirs add
alias dg = dirs goto
alias dn = dirs next
alias dp = dirs prev
alias dr = dirs drop
alias fetch = fastfetch
alias follow = readlink -f
alias p = pueue
alias snapper = snapper -c home
alias zl = zellij

alias cringe = sudo bootctl set-oneshot auto-windows

def h [query?: path] {
  (if ($query != null) {sk -1 -q ($query | path basename)} else {sk -1}) 
  | complete
  | if $in.exit_code == 0 {
      $in.stdout | str trim | hx $in
    }
}

def srg [] {
  sk --ansi -i -c 'rg --color=always --line-number "{}"'
}

alias j = jj
alias ja = jj log -r 'all()'
alias jc = jj desc
alias jd = jj diff
alias je = jj edit
alias jf = jj git fetch
alias jg = jj git clone --colocate
alias jp = jj git push
alias js = jj status
alias jw = jj workspace update-stale

def jm --wrapped [-r: string = "@", ...rest] {
  mut r = $r
  if (jj log -r @ --no-pager --no-graph --template 'if(empty,"empty")' | $in == "empty") {
    $r = "@-"
  }
  jj bookmark set main -r $r ...$rest
  jj git push
}

alias la = ls -a
alias ll = ls -l
alias lal = ls -la
alias ccp = cp -prv
alias mvp = mv-full -pv

def --env c [path: path = "~"] {
  cd $path
  l
}

def l --wrapped [...rest] {
  ls -t ...$rest | insert ext {|row| $row.name | parse "{name}.{ext}" | get ext | get 0? } | sort-by type ext name | reject type ext
}

alias list-automounts = systemctl list-units --type=automount

def remount [] {
  let reload = list-automounts | detect columns -n | get column0 | input list --multi
  for mount in $reload {
    systemctl restart $mount
  }
}

def cpedit [file: path] {
  mv $file $"($file).sym"; cp $"($file).sym" $file; chmod +w $file
}

alias core-job = job
alias job = job list
