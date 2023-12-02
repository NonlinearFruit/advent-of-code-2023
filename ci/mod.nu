export def test [] {
 use std testing run-tests
 run-tests
}

export def "test count" [] {
 use std testing run-tests
 run-tests --list 
 | get test 
 | flatten
 | length
}

export def "pull puzzle" [day?:string] {
  if day == null {
    mut day = date now | format date "%d"
  }
  let year = 2023
  let folder = $"day-($day)"
  mkdir $folder
  aoc -y $year -d $day download --overwrite --input-file $"($folder)/input" --puzzle-file $"($folder)/README.md"
}

export def "submit answer" [] {
}

export def "run puzzle" [day?:string] {
  if day == null {
    mut day = date now | format date "%d"
  }
  let folder = (ls | get name | where (str contains $day) | first) 
  print $folder
}

export def "star count" [] {
  aoc calendar
  | lines
  | where (str ends-with '*')
  | str replace -r '^.*?([*]+)$' '${1}'
  | str join
  | str length
}

export def "update readme" [] {
}
