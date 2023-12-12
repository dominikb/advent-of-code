require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 12)
example = <<~EXAMPLE
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
EXAMPLE

example = example.split("\n").map(&:strip)

def parse(input)
    input.map do |line|
        # Add a working spring at the end of a line to be able to ignore the possiblity of a broken spring at the end
        springs = line.split(" ").first.chars + ['.']
        groups = line.split(" ").last.split(",").map(&:to_i)

        { springs: springs, groups: groups }
    end
end

CACHE = {}
def cached_count(s, groups, prev_broken = 0)
    cache_key = [s, groups, prev_broken].hash
    CACHE[cache_key] ||= count(s, groups, prev_broken)
end
def count(s, groups, prev_broken = 0)
    if groups.empty? && s.any? { _1 == '#' }
        return 0
    end

    if s.empty? && groups.empty?
        return 1
    end
    
    total = 0
    if s[0] == '.' && prev_broken == 0
        total += cached_count(s[1..], groups)
    end

    if s[0] == '.' && prev_broken == groups&.first
        total += cached_count(s[1..], groups[1..])
    end

    if s[0] == '#' && prev_broken < (groups.first || 0)
        total += cached_count(s[1..], groups, prev_broken + 1)
    end

    if s[0] == '?' && prev_broken == 0
        total += cached_count(s[1..], groups)
    end

    if s[0] == '?' && prev_broken == groups&.first
        total += cached_count(s[1..], groups[1..])
    end

    if s[0] == '?' && prev_broken < (groups.first || 0)
        total += cached_count(s[1..], groups, prev_broken + 1)
    end

    total
end

def part1(input)
    grid = parse(input)

    grid.sum do |row, i|
        count(*row.values_at(:springs, :groups))
    end
end

def part2(input)
    unfolded_input = input.map do |line|
        springs = line.split(" ").first
        groups = line.split(" ").last.split(",").map(&:to_i)

        [([springs] * 5).join('?'), (groups * 5).join(',')].join(' ')
    end

    part1(unfolded_input)
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
