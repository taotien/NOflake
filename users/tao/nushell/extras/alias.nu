alias b = btm
alias d = sudo dmesg -w
alias p = pueue
alias zl = zellij
alias fetch = fastfetch
alias snapper = snapper -c home
alias follow = readlink -f
# alias cringe = sudo bootctl set-oneshot auto-windows

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

alias quiet = sudo ectool fanduty 42
alias loud = sudo ectool autofanctrl
alias louder = sude ectool fanduty 100

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
alias ccp = cp -prv
alias mvp = mv-full -pv

def --env c [path: path = "~"] {
  cd $path
  l
}

def l --wrapped [path: path = ".", ...rest] {
  ls ...$rest $path | sort-by type name -i -n
}
