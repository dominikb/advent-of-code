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

def part1(path : String) = {
  
  val input = Source.fromFile(path)
                  .getLines
                  .map(line => line.toInt)
                  .toList

  // val result = countIncreasing(input)
  val result = input.sliding(2).count { 
    case Seq(a, b) => a < b
    case _ => false
  }
  println(result)
}

def part2(path: String) = {
  val input = Source.fromFile(path)
                  .getLines
                  .map(line => line.toInt)
                  .toList

  val result = input.sliding(3).map(_.sum).sliding(2).count {
    case Seq(a, b) => a < b
    case _ => false
  }
  
  println(result)
}

