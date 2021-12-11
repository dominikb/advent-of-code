import scala.io.Source
import scala.collection.mutable.TreeSet
import scala.collection.mutable.TreeMap
import scala.collection.mutable.ArrayBuffer

def part1(path: String) = {
  var input = parseInput(path)

  val solution = input
  .flatMap(_._2)
  .count((digit: String) => List(2,3,4,7).contains(digit.length))

  println(solution)
}

def part2(path: String) = {
  var input = parseInput(path)

  val solution = input.map((hints, wanted) => {
    val mapping = combine(
      "abcdefg".toCharArray.toList,
      "abcdefg".toCharArray.toList
    ).map(it => {
      it.groupBy(_._1).map(it => (it._2)(0))
    }).filter(m => {
      hints.map(_.toCharArray.toList)
        .forall(wires => toDigit(wires, m) != None)
    }).head

    wanted
      .map(_.toCharArray.toList)
      .map(toDigit(_, mapping).get)
      .mkString
      .toInt
  }).sum

  println(solution)
}

// https://stackoverflow.com/a/21767189
def permList(l: List[Char]): List[List[Char]] = l match {
   case List(ele) => List(List(ele))
   case list =>
     for {
       i <- List.range(0, list.length)
       p <- permList(list.slice(0, i) ++ list.slice(i + 1, list.length))
     } yield list(i) :: p
}

def combine(a: List[Char], b : List[Char]) = 
  def combine(a: List[Char], permutatationB: List[Char]) =
    for(i <- 0 to a.length - 1)
      yield (a(i), permutatationB(i))

  for {
    perm <- permList(b.toList)
  } yield combine(a.toList, perm)

def toDigit(wires: List[Char], mappings: Map[Char, Char]) : Option[Int] =
  val mappedWires = wires.map(mappings(_)).sorted
  wiresPerDigit.filter((k,v) => v == mappedWires).keys.toList match
    case List(digit) => Some(digit)
    case _ => None

def wiresPerDigit = Map(
  0 -> "abcefg",
  1 -> "cf",
  2 -> "acdeg",
  3 -> "acdfg",
  4 -> "bcdf",
  5 -> "abdfg",
  6 -> "abdefg",
  7 -> "acf",
  8 -> "abcdefg",
  9 -> "abcdfg"
).mapValues(_.toCharArray.toList).toMap

def parseInput(path: String) : Seq[(List[String], List[String])] = {
  var input = Source
    .fromFile(path)
    .getLines
    .map(_.split(" \\| "))
    .map(parts => {
      val inputs = parts(0).split(" ").toList
      val outputs = parts(1).split(" ").toList
      (inputs, outputs)
    })
    .toSeq

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