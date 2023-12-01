# Advent of Code 2023

## How to pull a puzzle

- [Prerequisite] install [aoc-cli]
    ```sh
    cargo install aoc-cli
    ```
- [Prerequisite] Configure aoc [auth]

```sh
DAY=01
YEAR=2023
mkdir "day-$DAY"
cd "day-$DAY"
aoc -y "$YEAR" -d "$DAY" download
cd ..
git add "day-$DAY/"
git commit -m "Import puzzle for day $DAY"
```

[aoc-cli]: https://github.com/scarvalhojr/aoc-cli
[auth]: https://github.com/scarvalhojr/aoc-cli?tab=readme-ov-file#session-cookie-

