use assert

def decode [] {
  lines
  | str replace -a 'one' 'o1e'
  | str replace -a 'two' 't2'
  | str replace -a 'three' 't3e'
  | str replace -a 'four' '4'
  | str replace -a 'five' '5e'
  | str replace -a 'six' '6'
  | str replace -a 'seven' '7n'
  | str replace -a 'eight' 'e8'
  | str replace -a 'nine' '9'
  | str replace -ar '\D' ''
  | each {
    $in
    | split chars
    | $"($in | first)($in | last)"
    | into int
  }
}

export def "part 2" [] {
  open "day-01-trebuchet/input"
  | decode
  | reduce {|int, sum| $int + $sum }
}

#[test]
def test_module_solves_the_problem [] {
  assert equal 54019 (part 2)
}

#[test]
def test_decode_splits_lines [] {
  let result = $"1(char newline)5" | decode

  assert length $result 2
}

#[test]
def test_decode_removes_letters [] {
  let result = "1Ab2" | decode

  assert (($result | first | into string) !~ "A")
  assert (($result | first | into string) !~ "b")
}

#[test]
def test_decode_removes_middle_numbers [] {
  let result = "1337" | decode

  assert (($result | first | into string) !~ "3")
}

#[test]
def test_decode_returns_integers [] {
  let result = "37" | decode

  assert equal 37 ($result | first)
}

#[test]
def test_decode_handles_one [] {
  let result = "oneone" | decode

  assert equal 11 ($result | first)
}

#[test]
def test_decode_handles_two [] {
  let result = "twotwo" | decode

  assert equal 22 ($result | first)
}

#[test]
def test_decode_handles_three [] {
  let result = "threethree" | decode

  assert equal 33 ($result | first)
}

#[test]
def test_decode_handles_four [] {
  let result = "fourfour" | decode

  assert equal 44 ($result | first)
}

#[test]
def test_decode_handles_five [] {
  let result = "fivefive" | decode

  assert equal 55 ($result | first)
}

#[test]
def test_decode_handles_six [] {
  let result = "sixsix" | decode

  assert equal 66 ($result | first)
}

#[test]
def test_decode_handles_seven [] {
  let result = "sevenseven" | decode

  assert equal 77 ($result | first)
}

#[test]
def test_decode_handles_eight [] {
  let result = "eighteight" | decode

  assert equal 88 ($result | first)
}

#[test]
def test_decode_handles_nine [] {
  let result = "ninenine" | decode

  assert equal 99 ($result | first)
}

#[test]
def test_decode_handles_words_overlapping_with_eight [] {
  let result = "nineight" | decode

  assert equal 98 ($result | first)
}

#[test]
def test_decode_handles_words_overlapping_with_seven [] {
  let result = "sevenine" | decode

  assert equal 79 ($result | first)
}

#[test]
def test_decode_handles_words_overlapping_with_six [] {
  let result = "six not possible six" | decode

  assert equal 66 ($result | first)
}

#[test]
def test_decode_handles_words_overlapping_with_five [] {
  let result = "fiveight" | decode

  assert equal 58 ($result | first)
}

#[test]
def test_decode_handles_words_overlapping_with_four [] {
  let result = "four not possible four" | decode

  assert equal 44 ($result | first)
}

#[test]
def test_decode_handles_words_overlapping_with_three [] {
  let result = "eighthreeight" | decode

  assert equal 88 ($result | first)
}

#[test]
def test_decode_handles_words_overlapping_with_two [] {
  let result = "eightwo" | decode

  assert equal 82 ($result | first)
}

#[test]
def test_decode_handles_words_overlapping_with_one [] {
  let result = "twoneight" | decode

  assert equal 28 ($result | first)
}
