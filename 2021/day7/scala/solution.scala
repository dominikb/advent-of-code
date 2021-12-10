import scala.io.Source

def part1(path: String) = {
  var initialPositions = parseInput(path)

  var (target, costs) = possiblePositions(initialPositions)
    .map(target => (target, cost(initialPositions, target)))
    .minBy(a => a._2)

  println(s"Target: $target, Costs: $costs")
}

def part2(path: String) = {
  var initialPositions = parseInput(path)

  var (target, costs) = possiblePositions(initialPositions)
    .map(target => (target, cost2(initialPositions, target)))
    .minBy(a => a._2)

  println(s"Target: $target, Costs: $costs")
}

def possiblePositions(positions: Map[Long, Long]) : Seq[Long] =
  positions.keys.min.to(positions.keys.max)

def cost(start: Map[Long, Long], target: Long) : Long =
  start.map((p, n) => n * Math.abs(p - target)).sum

def cost2(start: Map[Long, Long], target: Long) : Long =
  start.map((p, n) => n * Math.abs(p - target).to(0, -1).sum).sum

def parseInput(path: String) : Map[Long, Long] = {
  var input = Source
    .fromFile(path)
    .getLines.toList(0).split(",")
    .groupMapReduce(_.toLong)(_ => 1L)(_ + _)

  return input
}

@main
def main() = {
  println("Part 1: ")
  print("Example: ")
  part1("../example.txt")
  print("Input: ")
  part1("../input.txt")
  println()

  println("Part 2: ")
  print("Example: ")
  part2("../example.txt")
  print("Input: ")
  part2("../input.txt")
  println()
}