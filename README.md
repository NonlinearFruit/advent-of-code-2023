# Advent of Code 2023


[![GitHub last commit (branch)](https://img.shields.io/github/last-commit/NonlinearFruit/advent-of-code-2023/master)](https://github.com/NonlinearFruit/advent-of-code-2023/commits/master/)
[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/NonlinearFruit/advent-of-code-2023/test.yml?label=tests)](https://github.com/NonlinearFruit/advent-of-code-2023/actions/workflows/test.yml)

## Pull a new puzzle

- [Prerequisite] install [aoc-cli]
    ```sh
    cargo install aoc-cli
    ```
- [Prerequisite] Configure aoc [auth]

```sh
DAY=01
YEAR=2023
mkdir "day-$DAY"
aoc -y "$YEAR" -d "$DAY" download --overwrite --input-file "day-$DAY/input" --puzzle-file "day-$DAY/README.md"
git add "day-$DAY/"
git commit -m "Import puzzle for day $DAY"
```

[aoc-cli]: https://github.com/scarvalhojr/aoc-cli
[auth]: https://github.com/scarvalhojr/aoc-cli?tab=readme-ov-file#session-cookie-

## Run tests

```sh
nu -c 'use std testing run-tests; run-tests'
 ````

## Run puzzle

```sh
nu -c 'use day-01-trebuchet go; go'
 ````

## Submit answer

```sh
DAY=1
YEAR=2023
PART=2

aoc -y "$YEAR" -d "$DAY" submit "$PART" "$(nu -c 'use day-01-trebuchet go; go')"
```
