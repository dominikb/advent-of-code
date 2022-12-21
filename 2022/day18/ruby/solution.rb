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
  Set.new [
    Set.new([[x, y, z], [x, y + s, z], [x + s, y + s, z], [x + s, y, z]]), # Front
    Set.new([[x, y, z + s], [x, y + s, z + s], [x + s, y + s, z + s], [x + s, y, z + s]]), # Back
    Set.new([[x, y, z], [x, y, z + s], [x + s, y, z + s], [x + s, y, z]]), # Bottom
    Set.new([[x, y + s, z], [x, y + s, z + s], [x + s, y + s, z + s], [x + s, y + s, z]]), # Top
    Set.new([[x, y, z], [x, y, z + s], [x, y + s, z + s], [x, y + s, z]]), # Left
    Set.new([[x + s, y, z], [x + s, y, z + s], [x + s, y + s, z + s], [x + s, y + s, z]]), # Right
  ]
end

def part1(input)
  cubes = input.map(&:integers).map { sides(_1, _2, _3) }

  count = 0
  for i in 0...cubes.size
    sides = cubes[i]
    for j in 0...cubes.size
      next if i == j
      sides -= cubes[j]
    end
    count += sides.size
  end
  count
end

def part2(input)
  coords = input.map(&:integers)
  xmin,xmax = coords.map(&:first).minmax
  ymin,ymax = coords.map(&:second).minmax
  zmin,zmax = coords.map(&:third).minmax

  [
    [xmin, xmax],
    [ymin, ymax],
    [zmin, zmax],
  ]
  # cubes = input.map(&:integers).map { sides(_1, _2, _3) }
  #
  # count = 0
  # for i in 0...cubes.size
  #   sides = cubes[i]
  #   for j in 0...cubes.size
  #     next if i == j
  #     sides -= cubes[j]
  #   end
  #   count += sides.size
  # end
  # count
end

puts "Part 1 (Example): #{part1(example)}"
# puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
# puts "Part 2: #{part2(input)}"
