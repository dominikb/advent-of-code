start = 264_360
ending = 746_325

defmodule PassCalc do
  def has_double?(number) when is_integer(number), do: has_double?(Integer.digits(number))
  def has_double?([head | tail]), do: has_double?(tail, [head])

  def has_double?([head | tail], window) do
    if (Enum.all?(window, &(&1 == head))) do
      has_double?(tail, [head | window])
    else
      length(window) == 2 or has_double?(tail, [head])
    end
  end

  def has_double?([], window), do: length(window) == 2

  def increasing_digits?(number) when is_integer(number) do
    increasing_digits?(Integer.digits(number))
  end

  def increasing_digits?([h | t]), do: increasing_digits?(t, h)

  def increasing_digits?([h | t], prev) do
    prev <= h and increasing_digits?(t, h)
  end

  def increasing_digits?([], _), do: true

  def candidates(from, to, count \\ 0) do
    eligable = has_double?(from) and increasing_digits?(from)

    cond do
      from >= to ->
        IO.puts("from: #{from}, to: #{to}, count: #{count}")

      eligable ->
        candidates(from + 1, to, count + 1)

      true ->
        candidates(from + 1, to, count)
    end
  end
end

IO.puts(PassCalc.candidates(start + 1, ending - 1))
