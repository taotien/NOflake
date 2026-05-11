export def "nu-complete docker start" [] {
  docker ps --all --format json | from json --objects | select Names Image | rename value description
}

export extern "docker start" [
  ...recipe: string@"nu-complete docker start"
]
