input = File.readlines(__dir__ + '/../input.txt').map(&:strip)
example = File.readlines(__dir__ + '/../example.txt').map(&:strip)

def next_gen(population)
  new_population = Hash.new(0)
  (0..7).each { |i| new_population[i] = population[i + 1] }
  new_population[6] += population[0]
  new_population[8] += population[0]
  new_population
end

def part1(input)
  initial = input.first
                 .split(',')
                 .map(&:to_i)
                 .group_by(&:itself)
                 .transform_values(&:size)
                 .tap { _1.default = 0 }

  population = initial
  80.times.each do |i|
    population = next_gen(population)
  end

  population.values.sum
end

def part2(input)

  initial = input.first
                 .split(',')
                 .map(&:to_i)
                 .group_by(&:itself)
                 .transform_values(&:size)
                 # .transform_values { Bignum.try_convert(_1.size)}
                 .tap { _1.default = 0 }

  population = initial
  256.times.each do |i|
    population = next_gen(population)
  end

  population.values.sum
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
