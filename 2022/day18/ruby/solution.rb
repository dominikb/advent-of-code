require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 18)
example = <<~EXAMPLE
  2,2,2
  1,2,2
  3,2,2
  2,1,2
  2,3,2
  2,2,1
  2,2,3
  2,2,4
  2,2,6
  1,2,5
  3,2,5
  2,1,5
  2,3,5
EXAMPLE
example = example.split("\n").map(&:strip)

def sides(x, y, z)
  s = 1 # Cube size
  [
    Set.new([[x, y, z], [x, y + s, z], [x + s, y + s, z], [x + s, y, z]]), # Front
    Set.new([[x, y, z + s], [x, y + s, z + s], [x + s, y + s, z + s], [x + s, y, z + s]]), # Back
    Set.new([[x, y, z], [x, y, z + s], [x + s, y, z + s], [x + s, y, z]]), # Bottom
    Set.new([[x, y + s, z], [x, y + s, z + s], [x + s, y + s, z + s], [x + s, y + s, z]]), # Top
    Set.new([[x, y, z], [x, y, z + s], [x, y + s, z + s], [x, y + s, z]]), # Left
    Set.new([[x + s, y, z], [x + s, y, z + s], [x + s, y + s, z + s], [x + s, y + s, z]]), # Right
  ]
end

def part1(input)
  input
    .map(&:integers)
    .flat_map { sides(_1, _2, _3) }
    .tally
    .filter { _2 == 1 }
    .size
end

# Expand from origin in all directions and return the list of cubes describing the air bubble.
#
# If the bubble goes out of bounds in any direction we return an empty array.
def fill_air_bubble(coords, origin, xrange, yrange, zrange)
  visited = []
  to_check = [origin]

  while to_check.not_empty?
    x,y,z = to_check.shift

    visited << [x,y,z]

    neighbours = [
      [x - 1, y, z], [x + 1, y, z],
      [x, y - 1, z], [x, y + 1, z],
      [x, y, z - 1], [x, y, z + 1],
    ].each do |n|
      return [] unless xrange.include?(x) && yrange.include?(y) && zrange.include?(z)
      to_check << n unless coords.key?(n)
    end
    to_check << [x - 1, y, z] unless coords.key?([x - 1, y, z])
  end

  visited
end

def part2(input)
  coords = input.map(&:integers).each_with_object({}) do |(x,y,z), agg|
    agg[[x,y,z]] = true
  end

  xmin, xmax = coords.keys.map(&:first).minmax
  ymin, ymax = coords.keys.map(&:second).minmax
  zmin, zmax = coords.keys.map(&:third).minmax

  potential_air_bubbles = []
  for x in xmin..xmax
    for y in ymin..ymax
      for z in zmin..zmax
        next if coords.key?([x,y,z])
        potential_air_bubbles << [x,y,z]
      end
    end
  end

  bubbles = potential_air_bubbles.flat_map do |origin|
    fill_air_bubble(coords, origin, xmin..xmax, ymin..ymax, zmin..zmax)
  end

  (input.map(&:integers) + bubbles)
    .flat_map { sides(_1, _2, _3) }
    .tally
    .filter { _2 == 1 }
    .size
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
