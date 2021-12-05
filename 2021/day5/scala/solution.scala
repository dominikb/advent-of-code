import scala.io.Source
import scala.collection.mutable.Map

case class Point(x : Int, y : Int)
case class Path(start : Point, end : Point)

def part1(path: String) = {
  val paths = parseInput(path)

  val ground = Map[Point, Int]().withDefault(_ => 0)
  for(point <- paths.flatMap(pointsInStraightPath))
    ground(point) = ground(point) + 1

  println(ground.values.count(_ > 1))
}

def part2(path: String) = {
  val paths = parseInput(path)

  val ground = Map[Point, Int]().withDefault(_ => 0)
  val points = paths.flatMap(pointsInStraightPath)
            ++ paths.flatMap(pointsInDiagonalPath)
  for(point <- points)
    ground(point) = ground(point) + 1
  
  println(ground.values.count(_ > 1))
}

def isDiagonal(p : Path) =
   Math.abs(p.start.x - p.end.x) == Math.abs(p.start.y - p.end.y)
def isStraight(p: Path) = isHorizontal(p) || isVertical(p)
def isHorizontal(p: Path) = p.start.x == p.end.x
def isVertical(p: Path) = p.start.y == p.end.y
def pointsInStraightPath(p : Path) : Seq[Point] = {
  if ! isStraight(p) then
    return Seq()
    
  val xRange = 
    if p.start.x < p.end.x then
      p.start.x to p.end.x
    else
      p.end.x to p.start.x

  val yRange = 
    if p.start.y < p.end.y then
      p.start.y to p.end.y
    else
      p.end.y to p.start.y

  if p.start.x != p.end.x && p.start.y != p.end.y then
    return Seq()

  for(x <- xRange; y <- yRange)
    yield Point(x, y)
}

def pointsInDiagonalPath(p: Path) : Seq[Point] = {
  if ! isDiagonal(p) then
    return Seq()

  val deltaX = if p.start.x < p.end.x then 1 else -1
  val deltaY = if p.start.y < p.end.y then 1 else -1
  val distance = Math.abs(p.start.x - p.end.x)

  for(steps <- 0 to distance)
    yield Point(p.start.x + steps * deltaX, p.start.y + steps * deltaY)
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