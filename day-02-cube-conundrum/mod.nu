use assert

const max_red = 12
const max_green = 13
const max_blue = 14

def "parse result" [it] {
  {
    red: ( if $in =~ "red" { $it | str replace -r '.*?(\d+) red.*' '${1}' | into int } else { 0 } )
    green: ( if $in =~ "green" { $it | str replace -r '.*?(\d+) green.*' '${1}' | into int } else { 0 } )
    blue: ( if $in =~ "blue" { $it | str replace -r '.*?(\d+) blue.*' '${1}' | into int } else { 0 } )
  }
}

def "parse game" [it] {
  {
    id: ($it | parse -r 'Game (?<id>\d+):.*' | get id | first | into int)
    results: ($it | split row ': ' | last | split row '; ' | each {|it| parse result $it})
  }
}

def "is valid" [it] {
  if $it.red > $max_red {
    false
  } else if $it.green > $max_green {
    false
  } else if $it.blue > $max_blue {
    false
  } else {
    true
  }
}

def "reduce game" [it] {
  {
    id: $it.id
    red: ($it.results | get red | math max)
    green: ($it.results | get green | math max)
    blue: ($it.results | get blue | math max)
  }
}

def "possible sum" [] {
  lines
  | each {|game| parse game $game | reduce game $in}
  | where {|game| is valid $game}
  | get id
  | reduce {|id sum| $id + $sum}
}

def power [] {
  lines
  | each {|game| parse game $game | reduce game $in}
  | reduce -f 0 {|game sum| $game.red * $game.green * $game.blue + $sum}
}

export def "part 1" [] {
  open "day-2/input"
  | possible sum
}

export def "part 2" [] {
  open "day-2/input"
  | power
}

#[test]
def test_example_one_works [] {
"Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
  | possible sum
  | assert equal 8 $in
}

#[test]
def test_example_two_works [] {
"Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
  | power
  | assert equal 2286 $in
}

#[test]
def test_parse_game_works [] {
  let game = "Game 1: 3 blue, 4 red; 5 red; 5 green" | parse game $in

  assert equal 1 $game.id
  assert equal 3 ($game.results | length)
}

#[test]
def test_parse_result_defaults_to_zero [] {
  let result = "" | parse result $in

  assert equal 0 $result.red
  assert equal 0 $result.green
  assert equal 0 $result.blue
}

#[test]
def test_parse_result_works [] {
  let result = "5 red, 6 green, 7 blue" | parse result $in

  assert equal 5 $result.red
  assert equal 6 $result.green
  assert equal 7 $result.blue
}

#[test]
def test_parse_result_works_with_double_digits [] {
  let result = "15 red, 16 green, 17 blue" | parse result $in

  assert equal 15 $result.red
  assert equal 16 $result.green
  assert equal 17 $result.blue
}

#[test]
def test_is_valid_works_for_good_results [] {
  let result = {
    red: 5
    green: 5
    blue: 5
  }

  assert (is valid $result)
}

#[test]
def test_is_valid_works_when_red_is_bad [] {
  let result = {
    red: ($max_red + 1)
    green: 5
    blue: 5
  }

  assert not (is valid $result)
}

#[test]
def test_is_valid_works_when_green_is_bad [] {
  let result = {
    red: 5
    green: ($max_green + 1)
    blue: 5
  }

  assert not (is valid $result)
}

#[test]
def test_is_valid_works_when_blue_is_bad [] {
  let result = {
    red: 5
    green: 5
    blue: ($max_blue + 1)
  }

  assert not (is valid $result)
}

#[test]
def test_reduce_game_works [] {
  let game = {
    id: 6
    results: [{
      red: 2
      green: 3
      blue: 4
    }]
  }

  let reduced_game = reduce game $game

  assert equal $game.id $reduced_game.id
  assert equal 2 $reduced_game.red
  assert equal 3 $reduced_game.green
  assert equal 4 $reduced_game.blue
}

#[test]
def test_reduce_game_works_with_multiples [] {
  let game = {
    id: 6
    results: [{
      red: 2
      green: 3
      blue: 4
    }
    {
      red: $max_red
      green: 3
      blue: 4
    }

    {
      red: 2
      green: $max_green
      blue: 4
    }
    {
      red: 2
      green: 3
      blue: $max_blue
    }]
  }

  let reduced_game = reduce game $game

  assert equal $max_red $reduced_game.red
  assert equal $max_green $reduced_game.green
  assert equal $max_blue $reduced_game.blue
}
