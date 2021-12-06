import scala.io.Source

def part1(path: String) = {
  val fishes = parseInput(path)
  println(simulate(fishes, 1, 80))
}

def part2(path: String) = {
  var fishes = parseInput(path)
  println(simulate(fishes, 1, 256))
}

def simulate(fishes : Map[Long, Long], day : Int, until : Int) : Long = {
  if (day > until)
    return fishes.values.sum

  val nextFishIteration = fishes.foldLeft(Map.empty[Long, Long].withDefault(_ => 0L)) {
    case (next, (0, nFish)) => 
      next ++ Map(
        6L -> (next(6L) + nFish),
        8L -> (next(8L) + nFish)
      )
    case (next, (day, nFish)) => 
      next + ((day - 1) -> (next(day - 1) + nFish))
  }
  
  simulate(nextFishIteration, day + 1, until)
}

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