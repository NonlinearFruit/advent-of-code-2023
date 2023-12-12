use assert
const input_file = "day-04-scratchcards/input"

def "parse ticket" [] {
  parse --regex 'Card \s*(?<id>\d+): (?<winners>.+) \| (?<actuals>.+)$'
  | update winners {|| str trim | split row -r ' +' | into int }
  | update actuals {|| str trim | split row -r ' +' | into int }
  | update id {|| into int }
  | first
}

def "parse tickets" [] {
  lines
  | each {|| parse ticket}
}

def "number of winners" [ticket] {
  $ticket.actuals 
  | reduce --fold 0 {|it, acc|
    if ($it in $ticket.winners) {
      $acc + 1
    } else {
      $acc
    }
  }
}

def "score ticket" [] {
  number of winners $in
  | match $in {
    $x if $x < 2 => $x
    $x => (2..$x | each {|| 2} | math product)
  }
}

def "score tickets from input" [] {
  parse tickets
  | each {|| score ticket}
  | math sum
}

def "find children" [tickets_left:table<id: int, winners: list<int>, actuals: list<int>> winner_count:int] {
  $tickets_left 
  | take $winner_count
  | enumerate
  | each {|enum|
    let ticket = $enum.item
    let index = $enum.index
    let winner_count = number of winners $ticket
    let tickets_remaining = $tickets_left | range ($index + 1)..
    let children = find children $tickets_remaining $winner_count
    if ($children | is-empty) {
      [ $ticket ]
    } else {
      $children | prepend $ticket
    }
  }
  | flatten
}

def "recurse tickets" [] {
  let tickets = $in
  $tickets
  | each {|ticket|
    let winner_count = number of winners $ticket
    let tickets_left = $tickets | range $ticket.id..
    $ticket | insert children (find children $tickets_left $winner_count)
  }
}

export def "part 1" [] {
  open $input_file
  | score tickets from input
}

export def "part 1 debug" [] {
  open $input_file
  | parse tickets
  | to json
}

export def "part 2" [] {
  open $input_file
  | parse tickets
  | to json
}

export def "part 2 debug" [] {
  let tickets = [
    {
      id: 1
      winners: [1 2 3]
      actuals: [1 2 3]
    }
    {
      id: 2
      winners: [1 2 3]
      actuals: [2 3 4]
    }
    {
      id: 3
      winners: [1 2 3]
      actuals: [3 4 5]
    }
    {
      id: 4
      winners: [1 2 3]
      actuals: [4 5 6]
    }
  ]

  $tickets | recurse tickets | to json
}

#[test]
def test_recurse_tickets_works [] {
  let tickets = [
    {
      id: 1
      winners: [1 2 3]
      actuals: [1 2 3]
    }
    {
      id: 2
      winners: [1 2 3]
      actuals: [2 3 4]
    }
    {
      id: 3
      winners: [1 2 3]
      actuals: [3 4 5]
    }
    {
      id: 4
      winners: [1 2 3]
      actuals: [4 5 6]
    }
  ]

  let all_tickets = $tickets | recurse tickets

  assert equal 4 ($all_tickets | length)
  assert equal 7 ($all_tickets.0 | get children | length)
  assert equal 3 ($all_tickets.1 | get children | length)
  assert equal 1 ($all_tickets.2 | get children | length)
  assert equal 0 ($all_tickets.3 | get children | length)
}

#[test]
def test_part_one_works [] {
  open $input_file
  | score tickets from input
  | assert equal 25174 $in
}

#[test]
def test_part_one_example_works [] {
"Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
  | score tickets from input
  | assert equal 13 $in
}

#[test]
def test_score_ticket_with_triple_match [] {
  let ticket = {
    id: 1
    winners: [1 2 3]
    actuals: [1 2 3]
  }

  let score = $ticket | score ticket

  assert equal 4 $score
}

#[test]
def test_score_ticket_with_double_match [] {
  let ticket = {
    id: 1
    winners: [1 2 3]
    actuals: [2 3 4]
  }

  let score = $ticket | score ticket

  assert equal 2 $score
}

#[test]
def test_score_ticket_with_single_match [] {
  let ticket = {
    id: 1
    winners: [1 2 3]
    actuals: [3 4 5]
  }

  let score = $ticket | score ticket

  assert equal 1 $score
}

#[test]
def test_score_ticket_with_no_match [] {
  let ticket = {
    id: 1
    winners: [1 2 3]
    actuals: [4 5 6]
  }

  let score = $ticket | score ticket

  assert equal 0 $score
}

#[test]
def test_parse_tickets_works [] {
  let tickets = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11" | parse tickets
  
  assert equal 6 ($tickets | length)
  assert equal 6 ($tickets | last | get id)
}

#[test]
def test_parse_ticket_works [] {
  let ticket = ("Card   1:   41 48 83 86 17 |   83 86  6 31 17  9 48 53" | parse ticket)

  assert equal 1 ($ticket | get id)
  assert equal [41 48 83 86 17] ($ticket | get winners)
  assert equal [83 86  6 31 17  9 48 53] ($ticket | get actuals)
}
