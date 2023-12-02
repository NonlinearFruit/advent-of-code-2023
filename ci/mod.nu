def "test count" [] {
 use std testing run-tests
 run-tests --list 
 | get test 
 | flatten
 | length
}

def "star count" [] {
  aoc calendar
  | lines
  | where (str ends-with '*')
  | str replace -r '^.*?([*]+)$' '${1}'
  | str join
  | str length
}

def docs [] {
  help modules
  | where $it.name == ci
  | first
  | get commands.name
  | each {
    $"
<details>
<summary>
nu -c 'use ci; ci ($in)'
</summary>

```
(help $in)
```
</details>"
  }
  | str join (char newline)
  | ansi strip
}

# Runs all the unit tests
export def test [] {
 use std testing run-tests
 run-tests
}

# Download the puzzle input and description
export def "pull puzzle" [day?:string] {
  if day == null {
    mut day = date now | format date "%d"
  }
  let year = 2023
  let folder = $"day-($day)"
  mkdir $folder
  aoc -y $year -d $day download --overwrite --input-file $"($folder)/input" --puzzle-file $"($folder)/README.md"
}

# Submit an answer to a puzzle
export def "submit answer" [day?:string] {
  if day == null {
    mut day = date now | format date "%d"
  }
  let year = 2023
  let part = 2
  aoc -y $year -d $day submit $part (run puzzle $day)
}

# Run a puzzle solver
export def "run puzzle" [day?:string] {
  if day == null {
    mut day = date now | format date "%d"
  }
  let folder = (ls | get name | where (str contains $day) | first) 
  print $folder
}

# Recalculate the README
export def "update readme" [] {
  let last_commit_badge = "[![GitHub last commit (branch)](https://img.shields.io/github/last-commit/NonlinearFruit/advent-of-code-2023/master)](https://github.com/NonlinearFruit/advent-of-code-2023/commits/master/)"
  let pipeline_badge = "[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/NonlinearFruit/advent-of-code-2023/test.yml?label=tests)](https://github.com/NonlinearFruit/advent-of-code-2023/actions/workflows/test.yml)"
  let star_count_badge = $"![star count]\(https://img.shields.io/badge/stars-(star count)-yellow)"
  let test_count_badge = $"![test count]\(https://img.shields.io/badge/tests-(test count)-blue)"

  $"
# Advent of Code 2023

($last_commit_badge)
($pipeline_badge)
($star_count_badge)
($test_count_badge)

```
(aoc calendar)
```

# Prerequisites

```
cargo install nushell # https://github.com/nushell/nushell
cargo install aoc-cli # https://github.com/scarvalhojr/aoc-cli
vim ~/.adventofcode.session # https://github.com/scarvalhojr/aoc-cli?tab=readme-ov-file#session-cookie-
```

# Usage
(docs)
    "
  | save -f README.md
}
