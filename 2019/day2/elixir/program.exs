defmodule OpCodeParser do
  def init(raw_opcodes) do
    opcodes =
      String.split(raw_opcodes, ",")
      |> Stream.map(&String.to_integer/1)
      |> Enum.chunk_every(4)

    %{
      instruction_pointer: 0,
      opcodes: opcodes
    }
  end

  def get_at(state, index) do
    row = div(index, 4)
    column = rem(index, 4)

    Enum.at(state.opcodes, row)
    |> Enum.at(column)
  end

  def put_at(state, index, value) do
    column_index = rem(index, 4)
    row_index = div(index, 4)

    new_row =
      Enum.at(state.opcodes, row_index)
      |> Enum.with_index()
      |> Enum.map(fn {old_value, index} ->
        if index == column_index do
          value
        else
          old_value
        end
      end)

    new_opcodes =
      Enum.with_index(state.opcodes)
      |> Enum.map(fn {old_row, index} ->
        if index == row_index do
          new_row
        else
          old_row
        end
      end)

    Map.put(state, :opcodes, new_opcodes)
  end

  def run(state) do
    operation = OpCodeParser.get_at(state, state.instruction_pointer)

    if operation == 99 do
      state
    else
      state = process(state, operation)
      run(state)
    end
  end

  defp process(state, 1) do
    OpCodeParser.do_process(state, &(&1 + &2))
  end

  defp process(state, 2) do
    OpCodeParser.do_process(state, &(&1 * &2))
  end

  def do_process(state, function) do
    [a, b] = OpCodeParser.next_two_values(state)

    index_c = OpCodeParser.get_at(state, state.instruction_pointer + 3)

    state =
      OpCodeParser.put_at(
        state,
        index_c,
        function.(a, b)
      )

    Map.put(state, :instruction_pointer, state.instruction_pointer + 4)
  end

  def next_two_values(state) do
    index_a = OpCodeParser.get_at(state, state.instruction_pointer + 1)
    index_b = OpCodeParser.get_at(state, state.instruction_pointer + 2)

    [
      OpCodeParser.get_at(state, index_a),
      OpCodeParser.get_at(state, index_b)
    ]
  end
end

initial_state =
  File.read!('../input.txt')
  |> String.trim()
  |> OpCodeParser.init()

target_result = 19_690_720

for n <- 0..99 do
  for k <- 0..99 do
    result =
      initial_state
      |> OpCodeParser.put_at(1, n)
      |> OpCodeParser.put_at(2, k)
      |> OpCodeParser.run()
      |> OpCodeParser.get_at(0)

    if result == target_result do
      IO.puts("n: #{n}, k: #{k}")
      IO.puts(100 * n + k)
    end
  end
end
