defmodule Orbit do
  def count(orbital_map) do
    for object <- Map.keys(orbital_map) do
      count_for(object, orbital_map)
    end
    |> Enum.sum()
  end

  defp count_for(object, orbital_map) do
    orbitations = Map.get(orbital_map, object, [])

    length(orbitations) +
      (for target <- orbitations do
         count_for(target, orbital_map)
       end
       |> Enum.sum())
  end

  def track_path(orbital_map, current, goal) do
    do_track_path(orbital_map, current, goal, nil, [])
  end

  defp do_track_path(orbital_map, current, goal, prev, path) do
    candidates =
      next_candidates(orbital_map, current)
      |> Enum.filter(&(&1 != prev))

    path = [current | path]

    cond do
      current == goal ->
        path

      Enum.empty?(candidates) ->
        []

      true ->
        for next <- candidates do
          do_track_path(orbital_map, next, goal, current, path)
        end
        |> Enum.filter(&(! Enum.empty?(&1)))
        |> Enum.flat_map(&(&1))
    end
  end

  def next_candidates(orbital_map, current) do
    Map.to_list(orbital_map)
    |> Enum.filter(fn {_from, to} -> Enum.member?(to, current) end)
    |> Enum.map(fn {from, _to} -> from end)
    |> Enum.concat(Map.get(orbital_map, current, []))
  end
end

input =
  File.read!("../input.txt")
  |> String.trim()
  |> String.splitter("\n")
  |> Stream.map(fn orbit_entry ->
    String.split(orbit_entry, ")") |> List.to_tuple()
  end)
  |> Enum.sort(fn {a, _}, {b, _} -> a < b end)
  |> Enum.reduce(%{}, fn {a, b}, acc ->
    Map.update(acc, b, [a], &[a | &1])
  end)

  path = Orbit.track_path(input, "YOU", "SAN")

IO.inspect(length(path) - 3)
