# ros2 / colcon completions via the argcomplete protocol they already ship
# (no native nu support exists for either; this talks the same env-var
# protocol their bash/zsh completion scripts use, minus the fd8 dance --
# thanks to _ARGCOMPLETE_STDOUT_FILENAME, no bash subshell needed).
export def "nu-complete argcomplete" [spans: list<string>] {
    let cmd = ($spans | first)
    if (which $cmd | is-empty) {
        return []
    }

    let line = ($spans | str join " ")
    let tmp = (^mktemp)

    with-env {
        _ARGCOMPLETE: "1"
        _ARGCOMPLETE_SHELL: "bash"
        _ARGCOMPLETE_SUPPRESS_SPACE: "1"
        _ARGCOMPLETE_STDOUT_FILENAME: $tmp
        COMP_LINE: $line
        COMP_POINT: ($line | str length | into string)
        COMP_TYPE: "9"
    } {
        ^$cmd | complete | ignore
    }

    let out = (open $tmp)
    rm -f $tmp
    $out | split row (char -i 11) | where {|x| $x != ""}
}

export def "nu-complete ros2-colcon" [spans: list<string>] {
    match ($spans | first) {
        "ros2" | "colcon" => (nu-complete argcomplete $spans)
        _ => null
    }
}
