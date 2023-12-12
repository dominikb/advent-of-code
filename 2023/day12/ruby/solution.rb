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

"""
?###????????
.###.##.#...
.###..##.#..
.###...##.#.  x
.###....##.#  x
.###.##..#..
.###.##...#.  x
.###.##....#  x
.###..##..#.  x
.###..##...#  x
.###...##..#  x

.###....##.#  x
.###...##..#  x
.###...##.#.  x
.###..##...#  x
.###..##..#.  x
.###.##....#  x
.###.##...#.  x

???????
...##.#
..##..#
..##.#.
.##...#
.##..#.
##....#
##...#.
"""

example = example.split("\n").map(&:strip)

class Cell
    attr_accessor :status

    STATUS = {
        :working => ".",
        :broken => "#",
        :unknown => "?",
    }

    STATUS.keys.each do |status|
        define_method("#{status}?") do
            @status == status
        end
        self.class.send(:define_method, status) do
            new(STATUS[status])
        end
    end

    def initialize(char)
        @status = STATUS.key(char)
    end

    def to_s
        STATUS[status]
    end

    def inspect
        to_s
        # "Cell<#{status}>"
    end
end

def parse(input)
    input.map do |line|
        springs = line.split(" ").first.chars.map(&Cell.method(:new))
        groups = line.split(" ").last.split(",").map(&:to_i)

        { springs: springs, groups: groups }
    end
end

def assert(condition, message)
    raise StandardError.new(message) unless condition 
end

def debug_puts(*args)
#    puts(*args)
end

def consume_group(springs, groups)
    assert(groups.size >= 1, "No group left to consume, but broken springs expected")
    size, *tail_groups = groups

    consumed = springs.take(size)
    peek, *tail_springs = springs.drop(size)

    valid_consume = consumed.all? { _1.broken? || _1.unknown? } && (peek.nil? || peek.working? || peek.unknown?)

    debug_puts "Consume #{size}: [#{consumed.map(&:to_s).join('')}|#{peek&.to_s}|#{tail_springs.map(&:to_s).join('')}] -> #{valid_consume}"

    return valid_consume
end

CACHE = {}
def key(springs, groups)
    [springs.map(&:to_s).join(''), groups.join(',')]
end

def memoized_possible_arrangements(springs, groups)
    CACHE[key(springs, groups)] ||= possible_arrangements(springs, groups)
end

def possible_arrangements(springs, groups)
    debug_puts "Check [#{springs.map(&:to_s).join()}] #{groups}"
    # Early stop
    if (groups.sum > springs.size)
        debug_puts "Early stop"
        return [false]
    end
    if groups.empty?
        if springs.any?(&:broken?)
            return [false] # Illegal solution
        else
            return [springs.map { Cell.working }]
        end
    end
    if springs.empty? && groups.any?
        return [false] # Illegal solution
    end

    head, *tail = springs
    if head.working?
        return possible_arrangements(tail, groups).filter_map do |arrangement|
            next if arrangement == false # no solution
            [head, *arrangement]
        end
    end

    if head.broken?
        return [false] unless consume_group(springs, groups) # Group can not be consumed

        group, *tail_groups = groups
        spring_rest = springs.drop(group + 1)
        prefix = [Cell.broken] * group + (if springs.size > group then [Cell.working] else [] end)

        debug_puts "Group #{group}, Prefix #{prefix.map(&:to_s).join('')}, Rest: #{springs.drop(group + 1).map(&:to_s).join('')}"

        return possible_arrangements(springs.drop(group + 1), tail_groups).filter_map do |arrangement|
            next if arrangement == false # no solution
            [*prefix, *arrangement]
        end
    end

    if head.unknown?
        assume_working = [Cell.working, *tail]
        assume_broken = [Cell.broken, *tail]

        debug_puts "Assume working: #{assume_working.map(&:to_s).join('')}"
        working = possible_arrangements(assume_working, groups)
        debug_puts "Working: [#{working.map(&:to_s).join('')}]"

        debug_puts "Assume broken: #{assume_broken.map(&:to_s).join('')}"
        broken = possible_arrangements(assume_broken, groups)
        debug_puts "Broken: [#{broken.map(&:to_s).join('')}]"

        return (broken + working).reject { _1 == false }
    end
end


def part1(input)
    grid = parse(input)

    # puts possible_arrangements("???????".chars.map { Cell.new(_1) }, [2, 1]).map { _1.join('') }.join("\n")

    grid.sum do |row|
        row => { springs:, groups: }
        arrangements = possible_arrangements(springs, groups)

        # puts "#{springs.map(&:to_s).join('').rjust(20, ' ')} #{arrangements.size.to_s.rjust(3, ' ')}"
        # puts arrangements.map { _1.join('') }.join(', ')
        # puts "#{arrangements.map { _1.map(&:to_s).join('') }.join("\n")}"
        # puts "\n" * 2

        arrangements.size
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
# puts "Part 2: #{part2(input)}"
