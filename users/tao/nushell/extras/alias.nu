alias xo = xdg-open
# alias h = hx (sk)
alias b = btm
alias cringe = sudo bootctl set-oneshot auto-windows
alias fetch = fastfetch
alias ff = firefox
alias pu = pueue
alias t = task
alias zl = zellij
alias snapper = snapper -c home
alias follow = readlink -f
alias la = ls -a

alias quiet = sudo ectool fanduty 42
alias loud = sudo ectool autofanctrl
alias louder = sude ectool fanduty 100

# alias cp-full = cp
alias ccp = cp -prv
# alias mv-full = mv
alias mvp = mv-full -pv

alias j = jj
alias ja = jj log -r 'all()'
alias jc = jj desc
alias jd = jj diff
alias je = jj edit
alias jf = jj git fetch
alias jg = jj git clone --colocate
# alias jm = jj bookmark set main
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
