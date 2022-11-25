input = File.readlines(__dir__ + '/../input.txt').map(&:strip)
example = File.readlines(__dir__ + '/../example.txt').map(&:strip)

def bit_counting(input)
  input
    .map { _1.split('') }
    .each_with_object(input.first.size.times.map { { zero: 0, one: 0 } }) do |binary, counter|
    binary.each_with_index do |value, index|
      case value
      in '1' then counter[index][:one] += 1
      in '0' then counter[index][:zero] += 1
      end
    end
  end
end

def gamma_rate(input)
  bit_counting(input).map { _1[:zero] > _1[:one] ? '0' : '1' }.join('').to_i(2)
end

def epsilon_rate(input)
  bit_counting(input).map { _1[:zero] > _1[:one] ? '1' : '0' }.join('').to_i(2)
end

def oxygen_generator_rating(input, look_at_index = 0)
  counted_bits = bit_counting(input)
  new_input = input.filter do |line|
    if counted_bits[look_at_index][:one] >= counted_bits[look_at_index][:zero]
      line[look_at_index] == '1'
    else
      line[look_at_index] == '0'
    end
  end
  return new_input.first.to_i(2) if new_input.size == 1

  oxygen_generator_rating(new_input, look_at_index + 1)
end

def co2_scrubber_rating(input, look_at_index = 0)
  counted_bits = bit_counting(input)
  new_input = input.filter do |line|
    if counted_bits[look_at_index][:zero] <= counted_bits[look_at_index][:one]
      line[look_at_index] == '0'
    else
      line[look_at_index] == '1'
    end
  end
  return new_input.first.to_i(2) if new_input.size == 1

  co2_scrubber_rating(new_input, look_at_index + 1)
end

def part1(input)
  gamma_rate(input) * epsilon_rate(input)
end

def part2(input)
  oxygen_generator_rating(input) * co2_scrubber_rating(input)
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
