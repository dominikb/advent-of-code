require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 20)
example = <<~EXAMPLE
  1
  2
  -3
  3
  -2
  0
  4
EXAMPLE
example = example.split("\n").map(&:strip)

class Item
  attr_reader :val, :position

  def initialize(val, original_position, max_len)
    @val = val
    @original_position = original_position
    @position = original_position
    @max_len = max_len
  end

  def move
    @position = @original_position + @val
    while @position < 0
      @position += @max_len
    end
    while @position > @max_len
      @position -= @max_len
    end
    self
  end

  def <=>(other)
    @position - other.position
  end

  def to_s
    "Item(#{@position},#{@val})"
  end
  def inspect = to_s
end

def to_list(numbers, movements)
  max = numbers.size
  numbers.map.with_index do |v, idx|
    new_idx = idx + movements[idx][0]
    while new_idx < 0
      new_idx += max
    end
    while new_idx > max
      new_idx -= max
    end
    [new_idx, v]
  end.sort_by(&:first).map(&:second)
end

def part1(input)
  numbers = input.map(&:to_i)
  # Hash of tuples(movements, original_idx, value)
  movements = Hash.new { _1[_2] = [0, _2, numbers[_2]] }
  max = input.size
  numbers.each_with_index do |v, i|
    puts "Moving #{v}"
    before = to_list(numbers, movements)
    movements[i][0] += v
    case v
    in 0 then next
    in _ if v > 0
      (i+1..i+v).each { movements[_1][0] -= 1 }
      (0...i+v-max).each { movements[_1][0] -= 1}
    in _ if v < 0 && v.abs > i
      (0...i).each { movements[_1][0] += 1 }
      (i+v+max..max).each { movements[_1][0] += 1}
    in _ if v < 0 && v.abs < i
      (i-v...i).each { movements[_1][0] += 1 }
    end
    after = to_list(numbers, movements)
    puts "After #{i + 1}: #{before} => #{after}"
  end
  to_list(numbers, movements)
end

def part2(input)
end

puts "Part 1 (Example): #{part1(example)}"
# puts "Part 1: #{part1(input)}"
# puts "Part 2 (Example): #{part2(example)}"
# puts "Part 2: #{part2(input)}"
