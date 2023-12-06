require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 6)
example = <<~EXAMPLE
Time:      7  15   30
Distance:  9  40  200
EXAMPLE


example = example.split("\n").map(&:strip)

def parse(input)
    times = input.first.split(' ').map(&:to_i)
    distances = input.last.split(' ').map(&:to_i)

    times.zip(distances).drop(1)
end

def hold_times_to_beat_the_record(time, distance)
    t_min = (0..time).lazy.find do |t|
        speed = t
        duration = (time - t)
        my_distance = speed * duration
        my_distance > distance
    end

    t_max = time.downto(0).lazy.find do |t|
        speed = t
        duration = (time - t)
        my_distance = speed * duration
        my_distance > distance
    end

    [t_min, t_max]
end

def part1(input)
    parse(input)
    .map { |time, distance| hold_times_to_beat_the_record(time, distance) }
    .map { |t_min, t_max| t_max - t_min + 1 }
    .reduce(:*)
end

def remove_bad_kerning(input)
    input.map do |line|
        header, *rest = line.split(' ')
        [header, rest.join].join(' ')
    end
end

def part2(input)
    part1(remove_bad_kerning(input))
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
