defmodule Day8 do
  use Application

  @layer_size 25 * 6

  def start(_type, _args) do
    input = File.read!("../input.txt")

    input
    |> layers()
    |> Enum.map(&String.to_charlist/1)
    |> resolve_visible_layer()
    |> Enum.chunk_every(25)
    |> Enum.map(&List.to_string/1)
    |> Enum.join("\n")
    |> String.replace("1", " ")
    |> IO.puts()
  end

  def layers(input) do
    input
    |> String.to_charlist()
    |> Enum.chunk_every(@layer_size)
    |> Enum.map(&Kernel.to_string/1)
  end

  def resolve_visible_layer([first | rest]) do
    resolve_visible_layer(rest, first)
  end

  def resolve_visible_layer([], visible_layer), do: visible_layer
  def resolve_visible_layer([next_layer | rest], visible_layer) do
    if still_transparent?(visible_layer) do
      visible_layer
    else
      new_visible_layer =
        Enum.zip(visible_layer, next_layer)
        |> IO.inspect()
        |> Enum.map(fn {visible_layer_pixel, next_layer_pixel} ->
          case visible_layer_pixel do
            50 ->
              next_layer_pixel
            _ ->
              visible_layer_pixel
          end
        end)

      resolve_visible_layer(rest, new_visible_layer)
    end
  end

  def still_transparent?(layer), do: Enum.any?(layer, &(&1 == '2'))
end
