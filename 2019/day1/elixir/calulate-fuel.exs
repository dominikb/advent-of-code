stream = File.stream!('../input.txt')

defmodule FuelCalculator do

  def for_mass(mass) when mass <= 6, do: 0
  def for_mass(mass) do
    fuel = Float.floor(mass / 3) - 2
    fuel + for_mass(fuel)
  end

end
stream
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Stream.map(&FuelCalculator.for_mass/1)
|> Enum.sum
|> IO.puts
