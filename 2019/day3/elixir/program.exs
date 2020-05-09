defmodule Wire do
  def parse_instruction_set(instructions) do
    instructions
    |> String.split(",")
    |> Stream.map(&Wire.parse_instruction/1)
    |> Enum.join()
  end

  def parse_instruction(instruction) do
    {direction, times} = String.split_at(instruction, 1)
    String.duplicate(direction, String.to_integer(times))
  end

  def start_position, do: %{x: 0, y: 0}

  def advance(position, <<next::utf8>> <> rest) do
    {axis, updater} =
      case <<next::utf8>> do
        "R" -> {:x, &(&1 + 1)}
        "L" -> {:x, &(&1 - 1)}
        "U" -> {:y, &(&1 + 1)}
        "D" -> {:y, &(&1 - 1)}
      end

    {
      Map.update!(position, axis, updater),
      rest
    }
  end
end

defmodule WireManager do
  def positions(instructions, acc \\ %{}) do
    positions(Wire.start_position(), instructions, acc)
  end

  def positions(_current, "", acc), do: acc

  def positions(current, instructions, acc) do
    {new_position, new_instructions} = Wire.advance(current, instructions)

    positions(
      new_position,
      new_instructions,
      Map.update(acc, new_position.x, [new_position.y], fn values -> [new_position.y | values] end)
    )
  end

  def intersections(wire1_positions, wire2_positions) do
      for {x, y_values} <- wire1_positions do
        case Map.get(wire2_positions, x) do
          nil ->
            []

          y2_values ->
            y2_values
            |> Enum.filter(&Enum.member?(y_values, &1))
            |> Enum.reduce([], fn y, acc -> [{x, y} | acc] end)
        end
      end
      |> Enum.filter(&(&1 != []))
      |> Enum.flat_map(&(&1))
  end

  def distance({x, y}) do
    abs(x) + abs(y)
  end

  def same?(pos1, pos2) do
    pos1.x == pos2.x and pos1.y == pos2.y
  end

  def steps_required(current_position, instructions, target_position, count \\ 0) do
    if same?(current_position, target_position) do
      count
    else
      {new_pos, new_instructions} = Wire.advance(current_position, instructions)
      steps_required(
        new_pos,
        new_instructions,
        target_position,
        count + 1
      )
    end
  end
end

{wire1_dir, wire2_dir} = File.read!("../input.txt")
|> String.trim()
|> String.split("\n")
|> Enum.map(&Wire.parse_instruction_set/1)
|> List.to_tuple()

intersections = WireManager.intersections(
  WireManager.positions(wire1_dir),
  WireManager.positions(wire2_dir)
)

way =
Enum.map(intersections, fn {x, y} ->
  steps1 = WireManager.steps_required(
    Wire.start_position,
    wire1_dir,
    %{x: x, y: y}
  )
  steps2 = WireManager.steps_required(
    Wire.start_position,
    wire2_dir,
    %{x: x, y: y}
  )

  {{x, y}, steps1, steps2}

end)
|> Enum.map(fn {_, dist_a, dist_b} -> dist_a + dist_b end)
|> Enum.sort

IO.inspect(way)
