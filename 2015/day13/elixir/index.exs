input = File.stream!(Path.join([__DIR__, '..', 'input.txt']));

#Mallory would gain 95 happiness units by sitting next to Carol.

input
|> Stream.map(fn line -> Regex.split(~r/(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)//) end)
|> Stream.map(
fn
  ([name1, _, "gain", happiness, _, _, _, _, _, _, name2]) -> {name1, name2, happiness}
  ([name1, _, "lose", happiness, _, _, _, _, _, _, name2]) -> {name1, name2, "-" <> happiness}
end
)
|> Enum.map(&IO.puts/1)
