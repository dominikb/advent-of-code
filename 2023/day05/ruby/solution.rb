require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 5)
example = <<~EXAMPLE
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
EXAMPLE

example = example.split("\n").map(&:strip)

Category = Struct.new(:name, :id)
class Mapping
    attr_accessor :from, :to, :dest_start, :src_start, :src_end, :length

    def initialize(from, to, dest_start, src_start, length)
        @from = from
        @to = to
        @dest_start = dest_start
        @src_start = src_start
        @src_end = src_start + length
        @length = length
    end

    def maps?(element)
         element.type == from
    end

    def covers?(element)
        element.id >= src_start && element.id < src_end
    end

    def transform(element)
        if covers?(element)
            offset = element.id - src_start
            Category.new(to, dest_start + offset)
        else
            nil
        end
    end

    def reverse
        Mapping.new(to, from, src_start, dest_start, length)
    end
end

def parse_mapping(mapping_str)
    heading, *mappings = mapping_str.strip.split("\n")
    from, _, to, _ = heading.split(/\-| /).map(&:to_sym)

    mappings.map do |mapping|
        dest, src, length = mapping.scan(/\d+/).map(&:to_i)
        Mapping.new(from, to, dest, src, length)
    end
end

def parse(input)
    seeds, *mappings = input.join("\n").split("\n\n")

    seeds = seeds.scan(/\d+/).map { Category.new(:seed, _1.to_i) }

    mappings = mappings
        .flat_map { |mapping| parse_mapping(mapping) }
        .group_by { _1.from }
        .transform_values do |mappings|
            from, to = mappings.first.from, mappings.first.to
            default_mapping = Mapping.new(from, to, 0, 0, Float::INFINITY)
            [*mappings, default_mapping]
        end
        .to_h

    [seeds, mappings]
end

def part1(input)
    seeds, mappings = parse(input)

    locations = seeds.map do |seed|
        while seed.name != :location
            mapper = mappings[seed.name].find { _1.covers?(seed) }
            seed = mapper.transform(seed)
        end
        seed
    end

    locations.map { _1.id }.sort.first
end

def part2(input)
    seeds, mappings = parse(input)

    all_seeds = seeds.each_slice(2).reduce(SparseRange.new) do |acc, slice|
        seed, next_seed = slice
        acc.add(seed.id...(seed.id + next_seed.id))
        acc
    end

    reverse_mappings = mappings.values.flatten.map(&:reverse).group_by(&:from).each do |from, mappings|
        [from, mappings]
    end.to_h

    (0..).lazy.map { Category.new(:location, _1) }.each do |current|
        location_id = current.id
        while current.name != :seed
            mapper = reverse_mappings[current.name].find { _1.covers?(current) }
            current = mapper.transform(current)
        end

        if all_seeds.cover?(current.id)
            return location_id
        end
    end
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
