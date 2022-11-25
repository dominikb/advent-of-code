input = File.readlines(__dir__ + '/../input.txt').map(&:strip)
example = File.readlines(__dir__ + '/../example.txt').map(&:strip)

class Cell
  attr_accessor :value, :marked

  def initialize(value, marked) = (@value, @marked = value, marked)
  def mark! = @marked = true
  def to_s = (marked ? "[#{value}]" : " #{value} ").ljust(4)
  def inspect = "Cell<value=#{value}, marked=#{marked}>"
end

class Board
  attr_accessor :rows, :bingo, :marked_values

  def initialize(rows) = (@rows, @bingo, @marked_values = rows, false, [])
  def columns = @cols ||= rows.transpose
  def finished? = (rows + columns).any? { _1.all?(&:marked) }
  def cells = rows.flatten
  def mark!(value)
    marked_cells = cells.select { _1.value == value }.map(&:mark!)
    @marked_values << value if marked_cells.any?
    @bingo = true if finished?
  end
  def bingo? = @bingo
  def sum
    cells.reject(&:marked).map(&:value).sum * @marked_values.last
  end

  def to_s
    rows.map { _1.map(&:to_s).join(' ') }.join("\n")
  end
end

def parse_board(string_rows)
  Board.new string_rows.map { _1.split(' ').map { |value| Cell.new(value.to_i, false) } }
end

def parse_boards_from_input(input)
  input
    .drop(2)
    .each_with_object([[]]) { |row, boards| row.empty? ? boards << [] : boards.last << row }
     .map { parse_board(_1) }
end

def part1(input)
  draws = input.first.split(',').map(&:to_i)
  boards = parse_boards_from_input(input)

  while not (boards.any?(&:bingo?)) and not draws.empty?
    draw = draws.shift
    boards.each do |board|
      board.mark!(draw)
    end
  end

  boards.find(&:bingo?).sum
end

def part2(input)
  draws = input.first.split(',').map(&:to_i)
  boards = parse_boards_from_input(input)

  while not boards.all?(&:bingo?) and not draws.empty?
    draw = draws.shift
    boards.each do |board|
      board.mark!(draw)
    end
    return boards.first.sum if boards.size == 1 and boards.first.bingo?
    boards.filter! { not _1.bingo? }
  end
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
