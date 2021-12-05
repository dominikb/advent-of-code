import scala.io.Source
import scala.collection.mutable.Map

case class Point(x : Int, y : Int)
case class Path(start : Point, end : Point) {
  def xStep : Int = if start.x < end.x then 1 else -1
  def yStep : Int = if start.y < end.y then 1 else -1
}

def part1(path: String) = {
  val paths = parseInput(path)

  val solution = paths
    .flatMap(pointsInStraightPath)
    .groupMapReduce(identity)(_ => 1)(_ + _)
    .values.count(_ > 1)

  println(solution)
}

def part2(path: String) = {
  val paths = parseInput(path)

  val solution = paths
    .flatMap(pointsInStraightPath)
    .appendedAll(paths.flatMap(pointsInDiagonalPath))
    .groupMapReduce(identity)(_ => 1)(_ + _)
    .values.count(_ > 1)
  
  println(solution)
}

def isDiagonal(p : Path) =
   Math.abs(p.start.x - p.end.x) == Math.abs(p.start.y - p.end.y)
def isStraight(p: Path) = isHorizontal(p) || isVertical(p)
def isHorizontal(p: Path) = p.start.x == p.end.x
def isVertical(p: Path) = p.start.y == p.end.y
def pointsInStraightPath(p : Path) : Seq[Point] = {
  if ! isStraight(p) then
    return Seq()
    
  val xRange = p.start.x to p.end.x by p.xStep
  val yRange = p.start.y to p.end.y by p.yStep

  for(x <- xRange; y <- yRange)
    yield Point(x, y)
}

def pointsInDiagonalPath(p: Path) : Seq[Point] = {
  if ! isDiagonal(p) then
    return Seq()

  for(steps <- 0 to Math.abs(p.start.x - p.end.x))
    yield Point(p.start.x + steps * p.xStep, p.start.y + steps * p.yStep)
}

val linePattern = "(\\d+),(\\d+) -> (\\d+),(\\d+)".r
def parseInput(path: String) : Seq[Path] = {
  val lines = Source
  .fromFile(path)
  .getLines
  .map(line => 
    line match
      case linePattern(x1, y1, x2, y2) => 
        Path(Point(x1.toInt, y1.toInt), Point(x2.toInt, y2.toInt))
  )

  lines.toSeq
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