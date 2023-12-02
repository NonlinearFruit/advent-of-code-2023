
# Advent of Code 2023

[![GitHub last commit (branch)](https://img.shields.io/github/last-commit/NonlinearFruit/advent-of-code-2023/master)](https://github.com/NonlinearFruit/advent-of-code-2023/commits/master/)
[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/NonlinearFruit/advent-of-code-2023/test.yml?label=tests)](https://github.com/NonlinearFruit/advent-of-code-2023/actions/workflows/test.yml)
![star count](https://img.shields.io/badge/stars-4-yellow)
![test count](https://img.shields.io/badge/tests-34-blue)

```

                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
            '             -                      
              ' .    -     -   * .                  3 
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
    