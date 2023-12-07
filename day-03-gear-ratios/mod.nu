use assert

def "group lines" [] {
  let input = $in
  if ($input | length) == 0 {
    []
  } else if ($input | length) == 1 {
    [$input]
  } else {
    generate $input {|lines| 
      if ($lines | length) > 2 {
        {
          out: ($lines | group 3 | first)
          next: ($lines | skip 1)
        }
      } else if ($lines | length) > 1 {
        {
          out: ($lines | append "")
          next: ($lines | skip 1)
        }
      } 
    }
    | prepend [["" $input.0 $input.1]]
  }
}

def "is not digit" [index] {
  let input = $in
  if $index < 0 {
    true
  } else {
    $input
    | str substring $index..($index + 1)
    | match $in {
      "0" => { false },
      "1" => { false },
      "2" => { false },
      "3" => { false },
      "4" => { false },
      "5" => { false },
      "6" => { false },
      "7" => { false },
      "8" => { false },
      "9" => { false },
      _ => { true }
    }
  }
}

def "find all indices" [candidate] {
  {
    line: $in
    begin: -1
  }
  | generate $in {|obj|
    if ($obj.begin + 1) <= ($obj.line | split chars | length) {
      let candidate_length = ($candidate | split chars | length)
      let index = $obj.line | str index-of $candidate --range ($obj.begin + 1)..
      let before_is_not_digit = $obj.line | is not digit ($index - 1)
      let after_is_not_digit = $obj.line | is not digit ($index + $candidate_length)
      if $index > $obj.begin {
        if $before_is_not_digit and $after_is_not_digit {
          {
            out: $index
            next: {
              line: $obj.line
              begin: $index
            }
          }
        } else {
          {
            next: {
              line: $obj.line
              begin: $index
            }
          }
        }
      }
    }
  }
}

def "parse group" [] {
  let group = $in
  let pre_line = $group.0
  let candidate_line = $group.1
  let post_line = $group.2
  $candidate_line
  | parse -r "(?<candidate>[0-9]+)" 
  | uniq-by candidate
  | each {|match|
    $candidate_line
    | find all indices $match.candidate
    | each {|index|
      let match_with_index = ($match | insert index $index)
      {
        id: (find surroundings $group $match_with_index | str replace -ra "[0-9.]" "")
        value: ($match.candidate | into int)
      }
    }
  }
  | flatten
  | where id != ""
}

def "find surroundings" [group match] {
  let pre_line = $group.0
  let candidate_line = $group.1
  let post_line = $group.2
  let candidate = ($match.candidate | into string)
  let size = ($candidate | split chars | length)
  let start_index = $match.index
  let end_index = $start_index + $size
  let boundary_start_index = ([0 ($start_index - 1)] | math max)
  let above = $pre_line | str substring $boundary_start_index..($end_index + 1)
  let before = ($candidate_line | str substring $boundary_start_index..$start_index)
  let after = ($candidate_line | str substring ($end_index)..($end_index + 1))
  let below = $post_line | str substring $boundary_start_index..($end_index + 1)

  $"($above)($before)($after)($below)"

}

def "sum engine parts" [] {
  lines
  | group lines
  | each {|group|
    $group | parse group
  }
  | flatten
  | get value
  | math sum
}

export def "part 1" [] {
  open "day-03-gear-ratios/input"
  | sum engine parts
}

export def "part 1 example" [] {
"467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."
  | sum engine parts
}

export def "part 1 debug" [] {
".........../..........................*.........................@...........*...*.......*.....................@.-...*.......................
........742.....................554...148..........812....*.........+..........727....875......#........./.........857.875...........*......
....................*.............+.....................................................................................*..................."
  | lines
  | group lines
  | each {|group|
    $group | parse group
  }
}

def "find surrounding ints" [group index] {
  let above_line = $group.0
  let candidate_line = $group.1
  let line_length = ($candidate_line | split chars | length)
  let below_line = $group.2
  let min_before = ([0 ($index - 3)] | math max)
  let min_before = ([0 ($index - 3)] | math max)
  let max_after = ([$line_length ($line_length - $index + 3)] | math min)
  [
    ($candidate_line | str substring ..$index | parse -r '(?<int>\d+)$' | get int | into int)
    ($candidate_line | str substring ($index + 1).. | parse -r '^(?<int>\d+)' | get int | into int)
  ]
  | if ($below_line | is not digit $index) {
      prepend [
        ($below_line | str substring ..$index | parse -r '(?<int>\d+)$' | get int | into int)
        ($below_line | str substring ($index + 1).. | parse -r '^(?<int>\d+)' | get int | into int)
      ]
    } else {
      prepend [
        ($below_line | str substring ($index - 2)..($index + 3) | parse -r '(^|\D)(?<int>\d\d\d)(\D|$)' | get int | into int)
        ($below_line | str substring ($index - 2)..($index + 3) | parse -r '(^|\D)(?<int>\d\d)(\D|$)' | get int | into int)
        ($below_line | str substring ($index - 2)..($index + 3) | parse -r '^.\D(?<int>\d)\D.$' | get int | into int)
        ($below_line | str substring ($index - 2)..($index + 3) | parse -r '^\D(?<int>\d)\D.$' | get int | into int)
        ($below_line | str substring ($index - 2)..($index + 3) | parse -r '^(?<int>\d)\D.$' | get int | into int)
        ($below_line | str substring ($index - 2)..($index + 3) | parse -r '^.\D(?<int>\d)$' | get int | into int)
        ($below_line | str substring ($index - 2)..($index + 3) | parse -r '^.\D(?<int>\d)\D$' | get int | into int)
      ]
    }
  | if ($above_line | is not digit $index) {
      prepend [
        ($above_line | str substring ..$index | parse -r '(?<int>\d+)$' | get int | into int)
        ($above_line | str substring ($index + 1).. | parse -r '^(?<int>\d+)' | get int | into int)
      ]
    } else {
      prepend [
        ($above_line | str substring ($index - 2)..($index + 3) | parse -r '(^|\D)(?<int>\d\d\d)(\D|$)' | get int | into int)
        ($above_line | str substring ($index - 2)..($index + 3) | parse -r '(^|\D)(?<int>\d\d)(\D|$)' | get int | into int)
        ($above_line | str substring ($index - 2)..($index + 3) | parse -r '^.\D(?<int>\d)\D.$' | get int | into int)
        ($above_line | str substring ($index - 2)..($index + 3) | parse -r '^\D(?<int>\d)\D.$' | get int | into int)
        ($above_line | str substring ($index - 2)..($index + 3) | parse -r '^(?<int>\d)\D.$' | get int | into int)
        ($above_line | str substring ($index - 2)..($index + 3) | parse -r '^.\D(?<int>\d)$' | get int | into int)
        ($above_line | str substring ($index - 2)..($index + 3) | parse -r '^.\D(?<int>\d)\D$' | get int | into int)
      ]
    }
  | flatten
}

# eye driven
def "find all gear indices" [] {
  split chars 
  | zip 0.. 
  | where {|it| $it.0 == "*"} 
  | each { $in.1 }
}

def "parse gears" [] {
  let group = $in
  let candidate_line = $group.1
  if ($candidate_line | str contains "*") {
    $candidate_line
    | find all gear indices
    | each {|index|
      {
        values: (find surrounding ints $group $index)
      }
    }
  } else {
    []
  }
}

def "sum gear ratios" [] {
  lines
  | group lines
  | each {|group|
    $group | parse gears
  }
  | flatten
  | where {|gear| $gear.values | length | $in == 2}
  | each {|gear| $gear.values | math product}
  | math sum
}

export def "part 2 debug" [] {
  open "day-03-gear-ratios/input"
  | lines
  | group lines
  | each {|group|
    $group | parse gears
  }
  | flatten
  | where {|gear| $gear.values | length | $in == 2}
  | get values
}

export def "part 2" [] {
  open "day-03-gear-ratios/input"
  | sum gear ratios
}

#[test]
def test_part_two_works [] {
  open "day-03-gear-ratios/input"
  | sum gear ratios
  | assert equal 72553319 $in
}

#[test]
def test_example_part_two [] {
"467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."
  | sum gear ratios
  | assert equal 467835 $in
}
#[test]
def test_find_surrounding_ints_handles_degenerate_case [] {
  let index = 0
  let group = [
    ""
    ""
    ""
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [] $ints
}

#[test]
def test_find_surrounding_ints_before [] {
  let index = 4
  let group = [
    ""
    "1234*...."
    ""
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [1234] $ints
}

#[test]
def test_find_surrounding_ints_above_when_there_are_two [] {
  let index = 4
  let group = [
    "1234.5678"
    "....*...."
    ""
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [1234 5678] $ints
}

#[test]
def test_find_surrounding_ints_below_when_there_are_two [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "1234.5678"
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [1234 5678] $ints
}

#[test]
def test_find_surrounding_ints_above_when_there_is_only_one_two_digit_on_the_right [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "....45..."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [45] $ints
}

#[test]
def test_find_surrounding_ints_above_when_there_is_only_one_two_digit_on_the_left [] {
  let index = 4
  let group = [
    "....137.."
    "....*...."
    ""
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [137] $ints
}

#[test]
def test_find_surrounding_ints_above_when_there_is_only_one_one_digit_in_middle [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "....5...."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [5] $ints
}

#[test]
def test_find_surrounding_ints_above_when_there_is_only_one_three_digit_in_middle [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "...456..."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [456] $ints
}

#[test]
def test_find_surrounding_ints_above_when_there_is_only_one_three_digit_on_left [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "..456...."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [456] $ints
}

#[test]
def test_find_surrounding_ints_above_when_there_is_only_one_three_digit_on_right [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "....456.."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [456] $ints
}

#[test]
def test_find_surrounding_ints_handles_above_edge_case [] {
  let index = 4
  let group = [
    "..0.7.0.."
    "....*...."
    ""
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [7] $ints
}

#[test]
def test_find_surrounding_ints_handles_below_edge_case [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "..0.7.0.."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [7] $ints
}

#[test]
def test_find_surrounding_ints_below_when_there_is_only_one_two_digit_on_the_right [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "....45..."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [45] $ints
}

#[test]
def test_find_surrounding_ints_below_when_there_is_only_one_two_digit_on_the_left [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "...45...."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [45] $ints
}

#[test]
def test_find_surrounding_ints_below_when_there_is_only_one_one_digit_in_middle [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "....5...."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [5] $ints
}

#[test]
def test_find_surrounding_ints_below_when_there_is_only_one_three_digit_in_middle [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "...456..."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [456] $ints
}

#[test]
def test_find_surrounding_ints_below_when_there_is_only_one_three_digit_on_left [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "..456...."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [456] $ints
}

#[test]
def test_find_surrounding_ints_below_when_there_is_only_one_three_digit_on_right [] {
  let index = 4
  let group = [
    ""
    "....*...."
    "....456.."
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [456] $ints
}

#[test]
def test_find_surrounding_ints_after [] {
  let index = 4
  let group = [
    ""
    "....*1234"
    ""
  ]

  let ints = (find surrounding ints $group $index)

  assert equal [1234] $ints
}

#[test]
def test_parse_gears_ignores_non_gears [] {
  [
  ""
  "....%.....&..."
  "...467...4...."
  ]
  | parse gears
  | assert equal [] $in 
}

#[test]
def test_parse_gears_ignores_red_herring [] {
  let expected = [{
    values: [4]
  }]

  [
  ""
  ".........*...."
  "...467...4...."
  ]
  | parse gears
  | assert equal $expected $in 
}

#[test]
def test_parse_gears_groups_by_gear [] {
  let expected = [
    {
      values: [2 3]
    }
    {
      values: [1 7]
    }
  ]

  [
  ""
  "...*3...*."
  "...2...1.7"
  ]
  | parse gears
  | assert equal $expected $in 
}

#[test]
def test_parse_gears_handles_single_good_candidate [] {
  let expected = [{
    values: [467]
  }]

  [
  ""
  "...*......"
  "467......."
  ]
  | parse gears
  | assert equal $expected $in 
}

#[test]
def test_parse_gears_handles_single_bad_candidate [] {
  [
  ""
  "467......."
  ".........."
  ]
  | parse gears
  | assert equal [] $in 
}

#[test]
def test_parse_gears_handles_end_of_line_match [] {
  [
  ".........."
  ".......123"
  ".........."
  ]
  | parse gears
  | assert equal [] $in 
}

#[test]
def test_parse_gears_handles_two_good_candidates [] {
  let result = [
  ""
  "...*....*."
  "467..114.."
  ]
  | parse gears

  assert equal 2 ($result | length)
  assert equal 114 $result.1.values.0
}

#[test]
def test_part_one_works [] {
  let  sum = (open "day-03-gear-ratios/input"
  | sum engine parts)

  assert equal 507214 $sum
}

#[test]
def test_tricky_line_with_875 [] {
".........../..........................*.........................@...........*...*.......*.....................@.-...*.......................
........742.....................554...148..........812....*.........+..........727....875......#........./.........857.875...........*......
....................*.............+.....................................................................................*..................."
  | sum engine parts
  | assert equal 4778 $in
}

#[test]
def test_part_one_last_five_lines_of_input_work [] {
".........................................................=........................$......*........$.........................................
...............408.914........788...%......@...................................660.....138....333..........48..............=380...104.......
.............$........-......*.......480...............194..*527........*....................*...............*578..961...........*..........
...444..428..470..........128...............684.399.....*............105.680......7*583............................*.......*....53....*.....
.....*.*...........223..........&19..........*.....*...246.....*........................526*939..........*....33..51....403..........706....
...832..383...287.........................216....103...........710..................958...................288..............................."
  | sum engine parts
  | assert equal 15508 $in
}

#[test]
def test_part_one_possibly_tricky_edge_case_with_five [] {
"..............*....#...............................................*............................@...........................................
..298-...5..158...........%307......+........+........165*..........836....$............*.......159..938.......*...%.....644................
...............................................................................+........................*................*.................."
  | sum engine parts
  | assert equal 3505 $in
}

#[test]
def test_part_one_possibly_tricky_edge_case_with_three [] {
"..................&....*........@........#..............................................................*...../..........*..................
.......400......*......676.....342.......930...389...925.......*...........580..3......395....................27....*....888..........#.....
.....%...........................................=..*......................*..........*....................................................."
  | sum engine parts
  | assert equal 5152 $in
}

#[test]
def test_part_one_possibly_tricky_edge_case_with_two [] {
"..........................*..................*...................*..........*.......................@................*..................*...
.........$..............#..817..424*89...&.117......../.....2..243.....................................279*143..866..458............623.170.
...........................................................-.........................../...........................................@........"
  | sum engine parts
  | assert equal 3365 $in
}


#[test]
def test_part_one_example_works [] {
"467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."
  | sum engine parts
  | assert equal 4361 $in
}

#[test]
def test_find_all_indicies_works [] {
  let indicies = "13..13...13....13.....13.."
  | find all indices "13"

  assert ($indicies | any {|i| $i == 0})
  assert ($indicies | any {|i| $i == 4})
  assert ($indicies | any {|i| $i == 9})
  assert ($indicies | any {|i| $i == 15})
  assert ($indicies | any {|i| $i == 22})
}

#[test]
def test_find_all_indicies_does_not_match_partial_numbers [] {
  let indicies = "136 does not match, but 13 should. 613 also shouldn't"
  | find all indices "13"

  assert equal 1 ($indicies | length)
  assert ($indicies | any {|i| $i == 24})
}

#[test]
def test_is_not_digit_handles_looking_after_string [] {
  "ABC"
  | is not digit (1)
  | assert equal true $in
}

#[test]
def test_is_not_digit_handles_looking_before_string [] {
  "ABC"
  | is not digit (-1)
  | assert equal true $in
}

#[test]
def test_is_not_digit_handles_non_digits [] {
  "A"
  | is not digit 0
  | assert $in
}

#[test]
def test_is_not_digit_handles_digits [] {
  "5"
  | is not digit 0
  | assert not $in
}

#[test]
def test_find_surroundings_finds_before_symbol [] {
  let group = [
  "....."
  "$467."
  "....."
  ]
 let match = {
   candidate: 467
   index: 1
 }

 let result = find surroundings $group $match

 assert str contains $result "$"
}

#[test]
def test_find_surroundings_finds_after_symbol [] {
  let group = [
  "....."
  ".467$"
  "....."
  ]
 let match = {
   candidate: 467
   index: 1
 }

 let result = find surroundings $group $match

 assert str contains $result "$"
}

#[test]
def test_find_surroundings_in_basic_case [] {
  let group = [
  "......"
  ".4678."
  "......"
  ]
 let match = {
   candidate: 4678
   index: 1
 }

 let result = find surroundings $group $match

 assert equal ".............." $result
}

#[test]
def test_find_surroundings_ignores_extra_fluff [] {
  let group = [
  "fluff......fluff"
  "fluff.4678.fluff"
  "fluff......fluff"
  ]
 let match = {
   candidate: 4678
   index: 6
 }

 let result = find surroundings $group $match

 assert not ($result | str contains "f")
}

#[test]
def test_parse_group_ignores_red_herring [] {
  let expected = [{
    id: "+"
    value: 4
  }]

  [
  ""
  "...467...4...."
  ".........+...."
  ]
  | parse group
  | assert equal $expected $in 
}

#[test]
def test_parse_group_removes_duplicates [] {
  let expected = [
    {
      id: "*"
      value: 467
    }
    {
      id: "*"
      value: 467
    }
  ]

  [
  ""
  "..467..467"
  "...*....*."
  ]
  | parse group
  | assert equal $expected $in 
}

#[test]
def test_parse_group_handles_single_good_candidate [] {
  let expected = [{
    id: "*"
    value: 467
  }]

  [
  ""
  "467......."
  "...*......"
  ]
  | parse group
  | assert equal $expected $in 
}

#[test]
def test_parse_group_handles_single_bad_candidate [] {
  [
  ""
  "467......."
  ".........."
  ]
  | parse group
  | assert equal [] $in 
}

#[test]
def test_parse_group_handles_end_of_line_match [] {
  [
  ".........."
  ".......123"
  ".........."
  ]
  | parse group
  | assert equal [] $in 
}

#[test]
def test_parse_group_handles_two_good_candidates [] {
  let expected = {
    id: "*"
    value: 114
  }

  let result = [
  ""
  "467..114.."
  "...*....*."
  ]
  | parse group

  assert equal 2 ($result | length)
  assert equal $expected.value $result.1.value
  assert equal $expected.id $result.1.id
}

#[test]
def test_group_lines_handles_empty [] {
  let groups = ([] | group lines)

  assert equal 0 ($groups | length)
}

#[test]
def test_group_lines_handles_single_line [] {
  let groups = ([""] | group lines)

  assert equal 1 ($groups | length)
}

#[test]
def test_group_lines_handles_two_lines [] {
  let groups = (["", ""] | group lines)

  assert equal 2 ($groups | length)
}

#[test]
def test_group_lines_groups_lines [] {
  let groups = (["a" "b" "c"] | group lines)

  assert equal ["" "a" "b"] ($groups.0)
  assert equal ["a" "b" "c"] ($groups.1)
  assert equal ["b" "c" ""] ($groups.2)
  assert equal 3 ($groups | length)
}
