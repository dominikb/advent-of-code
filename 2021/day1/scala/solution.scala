import scala.io.Source

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

def countIncreasing(measurements : List[Int]) : Int = {
  var count = 0
  for(i <- 1.to(measurements.size - 1))
    if measurements(i) > measurements(i - 1) then
      count = count + 1
  count
}

def part1(path : String) = {
  
  val input = Source.fromFile(path)
                  .getLines
                  .map(line => line.toInt)
                  .toList

  val result = countIncreasing(input)
  println(result)
}

def part2(path: String) = {
  val input = Source.fromFile(path)
                  .getLines
                  .map(line => line.toInt)
                  .toList

  val slidingWindowSize = 3
  var slidingWindows = scala.collection.mutable.Map[Int, Int]().withDefault(_ => 0)
  var slidingWindowIndex = 0;
  for(i <- 0 to input.length - slidingWindowSize) {
    for(j <- 0 to slidingWindowSize - 1) {
      slidingWindows(slidingWindowIndex) = slidingWindows(slidingWindowIndex) + input(i + j)
    }
    slidingWindowIndex = slidingWindowIndex + 1
  }
  val result = countIncreasing(slidingWindows.values.toList)
  println(result)
}

