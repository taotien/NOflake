export def "nu-complete docker ps" [] {
  docker ps --all --format json | from json --objects | select Names Image | rename value description
}

export extern "docker start" [
  ...recipe: string@"nu-complete docker ps"
]

export extern "docker stop" [
  ...recipe: string@"nu-complete docker ps"
]

export extern "docker restart" [
  ...recipe: string@"nu-complete docker ps"
]

export extern "docker rm" [
  ...recipe: string@"nu-complete docker ps"
]

export def --wrapped "docker bash" [
  name: string@"nu-complete docker ps"
  ...rest
] {
  docker exec -it -e DISPLAY $name bash ...$rest
}

