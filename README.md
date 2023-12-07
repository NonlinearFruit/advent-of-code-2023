
# Advent of Code 2023

[![GitHub last commit (branch)](https://img.shields.io/github/last-commit/NonlinearFruit/advent-of-code-2023/master)](https://github.com/NonlinearFruit/advent-of-code-2023/commits/master/)
[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/NonlinearFruit/advent-of-code-2023/test.yml?label=tests)](https://github.com/NonlinearFruit/advent-of-code-2023/actions/workflows/test.yml)
![star count](https://img.shields.io/badge/stars-6-yellow)
![test count](https://img.shields.io/badge/tests-89-blue)

```

                                                 
                                                 
                                                 
                                                 
                                                 
        *                                          12 
                                                 
      *                                            11 
            *                                      10 
                                                 
               *                                    9 
                    *                               8 
                                                 
                  *                                 7 
                                  *                 6 
                                                 
                                           *        5 
                 ...''''                         
              .''                  *                4 
            .'                    /              
            :             /\    -/  :            
            '.            -   - /  .'            
              '..    -     -   *..'                 3 **
    ----@        '''..*......'''                    2 **
  * ! /^\                                           1 **
```

# Prerequisites

```
cargo install nushell # https://github.com/nushell/nushell
cargo install aoc-cli # https://github.com/scarvalhojr/aoc-cli
vim ~/.adventofcode.session # https://github.com/scarvalhojr/aoc-cli?tab=readme-ov-file#session-cookie-
```

# Usage

<details>
<summary>
nu -c 'use ci; ci pull puzzle'
</summary>

```
Download the puzzle input and description

Usage:
  > pull puzzle (day) 

Flags:
  -h, --help - Display the help message for this command

Parameters:
  day <string>:  (optional)

Input/output types:
  ╭───┬───────┬────────╮
  │ # │ input │ output │
  ├───┼───────┼────────┤
  │ 0 │ any   │ any    │
  ╰───┴───────┴────────╯


```
</details>

<details>
<summary>
nu -c 'use ci; ci run puzzle'
</summary>

```
Run a puzzle solver

Usage:
  > run puzzle (day) 

Flags:
  -h, --help - Display the help message for this command

Parameters:
  day <string>:  (optional)

Input/output types:
  ╭───┬───────┬────────╮
  │ # │ input │ output │
  ├───┼───────┼────────┤
  │ 0 │ any   │ any    │
  ╰───┴───────┴────────╯


```
</details>

<details>
<summary>
nu -c 'use ci; ci submit answer'
</summary>

```
Submit an answer to a puzzle

Usage:
  > submit answer (day) 

Flags:
  -h, --help - Display the help message for this command

Parameters:
  day <string>:  (optional)

Input/output types:
  ╭───┬───────┬────────╮
  │ # │ input │ output │
  ├───┼───────┼────────┤
  │ 0 │ any   │ any    │
  ╰───┴───────┴────────╯


```
</details>

<details>
<summary>
nu -c 'use ci; ci test'
</summary>

```
Runs all the unit tests

Usage:
  > test 

Flags:
  -h, --help - Display the help message for this command

Input/output types:
  ╭───┬───────┬────────╮
  │ # │ input │ output │
  ├───┼───────┼────────┤
  │ 0 │ any   │ any    │
  ╰───┴───────┴────────╯


```
</details>

<details>
<summary>
nu -c 'use ci; ci update readme'
</summary>

```
Recalculate the README

Usage:
  > update readme 

Flags:
  -h, --help - Display the help message for this command

Input/output types:
  ╭───┬───────┬────────╮
  │ # │ input │ output │
  ├───┼───────┼────────┤
  │ 0 │ any   │ any    │
  ╰───┴───────┴────────╯


```
</details>

## Nushell v0.87.1: Lessons Learned

- Test result summary (eg: `Failed: 0 Passed: 50 Skipped: 5`)
- Printing test name _with_ the test error
- Printing filename + line + column with error
- Parameterized tests
- Nesting tests (eg: `describe`)
- Find regex matches in string with their corresponding index in the string (eg: 'day-3')
- Version specific documentation (eg: `v0.85.0` vs `v0.87.1`)
- Unexpected errors 'assert index wrong' that show the internal interpreter error and not the source code issue
- Unexpected errors 'to noun' that show the internal interpreter error and not the source code issue
  - `can't convert list<error> to NUON`
- Unexpected white space dependent syntax (eg: `1+1` vs `1 + 1`)
- `run-tests` should output structured data (eg: test name, status, execution time, etc)
- String interpolation parsing has unexpected behavior
   - Double quote allows escaping `(` and singles don't
- Negative asserts (eg: `assert not equal` or `assert does not contain`)