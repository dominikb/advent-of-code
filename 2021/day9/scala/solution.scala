import scala.io.Source

case class Pos(x: Int, y: Int)

def part1(path: String) = {
  var terrain = parseInput(path)

  val solution = positions(terrain)
    .filter(isLowPoint(_, terrain))
    .map(height(_, terrain) + 1)
    .sum
    
  println(solution)
}

def part2(path: String) = {
  var terrain = parseInput(path)

  val solution = positions(terrain)
    .filter(isLowPoint(_, terrain))
    .map(basin(_, terrain).size)
    .sorted
    .reverse
    .take(3)
    .product

  println(solution)
}

def basin(p: Pos, terrain: Array[Array[Int]]) : Set[Pos] =
  Set(p) ++ neighboursTo(p)
    .filter(height(_, terrain) > height(p, terrain))
    .filter(height(_, terrain) < 9)
    .flatMap(basin(_, terrain))
    .toSet

def positions(terrain: Array[Array[Int]]) : Seq[Pos] = 
  for {
    x <- 0 until terrain.length
    y <- 0 until terrain.head.length
  } yield Pos(x,y)

def isLowPoint(p: Pos, terrain: Array[Array[Int]]) =
  neighboursTo(p)
    .map(height(_, terrain))
    .forall(_ > height(p, terrain))

def neighboursTo(p: Pos) : List[Pos] =
  List(Pos(p.x - 1, p.y), Pos(p.x + 1, p.y), Pos(p.x, p.y - 1), Pos(p.x, p.y + 1))

def height(p: Pos, terrain : Array[Array[Int]]) : Int =
  if (p.x < 0 || p.x > terrain.length - 1) then
    return 9
  if (p.y < 0 || p.y > terrain.head.length - 1) then
    return 9
  terrain(p.x)(p.y)


def parseInput(path: String) : Array[Array[Int]] =  {
  var input = Source
    .fromFile(path)
    .getLines
    .map(_.split("").map(_.toInt))
    .toArray

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