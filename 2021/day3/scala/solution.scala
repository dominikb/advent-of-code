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

def parseInput(path: String) = {
  Source.fromFile(path)
  .getLines
  .toList
}

def binaryStringToInt(binary : String) =
  val (_, result) = binary.foldRight((0,0))((char, v) => {
    val (index, value) = v
    if (char == '1')
      (index + 1, value + math.pow(2, index).toInt)
    else
      (index + 1, value)
  })
  result

def part1(path: String) = {
  val input = parseInput(path)

  val lineCount = input.length
  val lineLength = input(0).length
  val count = Array.fill[Int](lineLength){0}

  for(line <- input; i <- (0 to lineLength - 1))
    if line(i) == '1' then
      count(i) = count(i) + 1

  var gamma = ""
  var epsilon = ""
  for(v <- count)
    if v > (lineCount / 2) then
      gamma = gamma + "1"
      epsilon = epsilon + "0"
    else
      gamma = gamma + "0"
      epsilon = epsilon + "1"

  val gammaVal = binaryStringToInt(gamma)
  val epsilonVal = binaryStringToInt(epsilon)
  val result = gammaVal * epsilonVal
  println(s"Result: $result")
}

def determineRatingByPrio(input: List[String], priority : Char, offset : Int = 0) : String = {
  if (input.length == 1)
    return input(0)

  if (input.length == 2)
    if input(0)(offset) == priority then
      return input(0)
    else
      return input(1)

  val (countZero, countOne) = input.foldLeft((0,0))((state, line) => {
    line(offset) match
      case '0' => (state._1 + 1, state._2)
      case '1' => (state._1, state._2 + 1)
  })

  val searchFor = priority match
    case '0' => if countZero <= countOne then '0' else '1'
    case '1' => if countOne >= countZero then '1' else '0'

  determineRatingByPrio(
    input.filter(it => it(offset) == searchFor),
    priority,
    offset + 1)    
}

def part2(path: String) = {
  val input = parseInput(path)

  val oxy = determineRatingByPrio(input, '1')
  val co2 = determineRatingByPrio(input, '0')
  println()
  println(s"oxy = $oxy = ${binaryStringToInt(oxy)}")
  println(s"co2 = $co2 = ${binaryStringToInt(co2)}")

  println(binaryStringToInt(oxy) * binaryStringToInt(co2))
}