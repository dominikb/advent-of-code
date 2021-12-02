import scala.io.Source
enum Direction:
  case forward, up, down

case class Move(direction: Direction, units: Int)

case class Position(horizontal : Int, depth: Int, aim: Int = 0)

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

def parseInput(path: String) = {
  Source.fromFile(path)
  .getLines
  .map((line: String) => {
    val Array(direction, units) = line.split(" ")
    Move(Direction.valueOf(direction), units.toInt)
  })
  .toList
}

def part1(path: String) = {
  val start = Position(0, 0)

  val stop = parseInput(path)
  .foldLeft(start)((position, nextMove) => {
    nextMove match {
      case Move(Direction.forward, n) => position.copy(position.horizontal + n)
      case Move(Direction.down, n) => position.copy(depth = position.depth + n)
      case Move(Direction.up, n) => position.copy(depth = position.depth - n)
    }
  })
  print(s"$stop = ")
  println(stop.depth * stop.horizontal)
}

def part2(path: String) = {
  val start = Position(0, 0, 0)

  val stop = parseInput(path)
  .foldLeft(start)((position, nextMove) => {
    nextMove match {
      case Move(Direction.forward, n) => position.copy(
        horizontal = position.horizontal + n,
        depth = position.depth + position.aim * n
      )
      case Move(Direction.down, n) => position.copy(aim = position.aim + n)
      case Move(Direction.up, n) => position.copy(aim = position.aim - n)
    }
  })
  print(s"$stop = ")
  println(stop.depth * stop.horizontal)
}