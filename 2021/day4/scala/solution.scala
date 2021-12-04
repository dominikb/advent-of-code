import scala.io.Source

type Board = List[List[Int]]
type Row = List[Int]
type Col = List[Int]
type Draws = List[Int]

def part1(path: String) = {
  val (draws, boards) = parseInput(path)

  var seenDraws = draws.take(4)
  var winningBoard : Option[Board] = None
  while winningBoard == None do 
    seenDraws = draws.take(seenDraws.length + 1)
    winningBoard = boards.find(isWinningBoard(_, seenDraws))

  val unmarkedNumbers = winningBoard.get
    .flatMap(row => row.filterNot(v => seenDraws.contains(v)))
  
  println(seenDraws.last * unmarkedNumbers.sum)
}


def part2(path: String) = {
  var (draws, boards) = parseInput(path)

  // Go until all but one board have won
  var seenDraws = draws.take(4)
  while boards.length > 1 do 
    seenDraws = draws.take(seenDraws.length + 1)
    boards = boards.filterNot(isWinningBoard(_, seenDraws))
  
  // Draw until the last board has won
  while (!isWinningBoard(boards.last, seenDraws)) do
    seenDraws = draws.take(seenDraws.length + 1)

  var unmarkedNumbers = boards.last
    .flatMap(row => row.filterNot(v => seenDraws.contains(v)))
  
  println(seenDraws.last * unmarkedNumbers.sum)
}

def isWinningBoard(b: Board, d: Draws) =
  rows(b).exists(isWinningRow(_, d)) || cols(b).exists(isWinningCol(_, d))
def isWinningRow(r: Row, d: Draws) = r.forall(d.contains(_))
def isWinningCol(c: Col, d: Draws) = isWinningRow(c, d)
def rows(b: Board) : List[Row] = b
def cols(b: Board) : List[Col] = b.transpose


def parseInput(path: String) : (Draws, List[Board]) = {
  val lines = Source.fromFile(path)
  .getLines

  val draws = lines.take(1).flatMap(_.split(",")).map(_.toInt).toList

  val boards = lines.drop(1).grouped(6).map(board => 
    board.take(5) // Skip empty 6th line if there
          .map(row => row.split("\\s+")
                .filter(_.nonEmpty)
                .map(_.toInt)
                .toList)
          .toList
  ).toList

  (draws, boards)
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