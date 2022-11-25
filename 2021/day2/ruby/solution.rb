input = File.readlines(__dir__ + '/../input.txt')
example = File.readlines(__dir__ + '/../example.txt')

def parse_command(line)
  command, value = line.split(' ')
  [command, value.to_i]
end

def part1(input)
  resulting_position = input
    .map(&method(:parse_command))
    .each_with_object({ depth: 0, horizontal: 0 }) do |cmd, position|
    direction, value = cmd
    case direction
    in "forward" then position[:horizontal] += value
    in "down" then position[:depth] += value
    in "up" then position[:depth] -= value
    end
  end

  resulting_position.values.reduce(&:*)
end

def part2(input)
  resulting_position = input
     .map(&method(:parse_command))
     .each_with_object({ depth: 0, horizontal: 0, aim: 0 }) do |cmd, position|
    direction, value = cmd
    case direction
    in "forward" then
      position[:horizontal] += value
      position[:depth] += position[:aim] * value
    in "down" then position[:aim] += value
    in "up" then position[:aim] -= value
    end
  end

  resulting_position.values_at(:depth, :horizontal).reduce(&:*)
end

puts "Example: #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"
