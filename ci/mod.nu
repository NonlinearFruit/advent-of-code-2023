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
  $'use assert

export def "part 1" [] {
  open $"($folder)/input"
}

export def "part 2" [] {
  open $"($folder)/input"
}'
  | save $"($folder)/mod.nu"
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
  nu -c $"use ($folder); ($folder) part 1"
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

## Nushell v0.87.1: Lessons Learned

- Test result summary \(eg: `Failed: 0 Passed: 50 Skipped: 5`)
- Printing test name _with_ the test error
- Printing filename + line + column with error
- Parameterized tests
- Nesting tests \(eg: `describe`)
- Find regex matches in string with their corresponding index in the string \(eg: 'day-3')
- Version specific documentation \(eg: `v0.85.0` vs `v0.87.1`)
- Unexpected errors 'assert index wrong' that show the internal interpreter error and not the source code issue
- Unexpected errors 'to noun' that show the internal interpreter error and not the source code issue
  - `can't convert list<error> to NUON`
- Unexpected white space dependent syntax \(eg: `1+1` vs `1 + 1`)
- `run-tests` should output structured data \(eg: test name, status, execution time, etc)
- String interpolation parsing has unexpected behavior
   - Double quote allows escaping `\(` and singles don't
- Negative asserts \(eg: `assert not equal` or `assert does not contain`)"
  | save -f README.md
}
