export def --wrapped  "jj-log" [
    -r: string = ""
    -n: int = 0
    --all(-a)
    ...rest
] {
    let tmpl = '
concat(
  "{",
  "\"change_id\":", json(change_id.short(8)), ",",
  "\"description\":", json(description.first_line().trim()), ",",
  "\"timestamp\":", json(author.timestamp().format("%Y-%m-%dT%H:%M:%S%:z")), ",",
  "\"bookmarks\":", json(bookmarks.map(|b| b.name())), ",",
  "\"empty\":", json(empty), ",",
  "\"current_wc\":", json(current_working_copy), ",",
  "}\n"
)
'

    mut args = [log --no-graph -T $tmpl]

    if $all {
        $args = ($args | append [-r "all()"])
    } else if $r != "" {
        $args = ($args | append [-r $r])
    }
    if $n > 0 {
        $args = ($args | append [-n ($n | into string)])
    }

    jj ...$args ...$rest
    | from json -o
    | update timestamp { into datetime }
}
