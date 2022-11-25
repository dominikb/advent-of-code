input = File.readlines(__dir__ + '/../input.txt')
example = File.readlines(__dir__ + '/../example.txt')

def part1(input)
  input.unshift(input.first)
       .map(&:to_i)
       .each_cons(2)
       .filter { _1 < _2 }
       .count
end

def part2(input)
  summed = input.map(&:to_i)
       .each_cons(3)
       .map(&:sum)

  part1(summed) - 1
end

puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"
