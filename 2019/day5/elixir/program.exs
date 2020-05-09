defmodule OpCodeParser do
  def init(raw_opcodes) do
    opcodes =
      String.split(raw_opcodes, ",")
      |> Enum.map(&String.to_integer/1)

    %{
      instruction_pointer: 0,
      opcodes: opcodes
    }
  end

  def get_at(state, index) do
    row = div(index, 4)
    column = rem(index, 4)

    Enum.at(state.opcodes, index)
  end

  def put_at(state, index, value) do
    new_opcodes =
      Enum.with_index(state.opcodes)
      |> Enum.map(fn {old_value, old_index} ->
        if index == old_index do
          value
        else
          old_value
        end
      end)

    Map.put(state, :opcodes, new_opcodes)
  end

  def run(state) do
    operation = OpCodeParser.get_at(state, state.instruction_pointer)
    |> Integer.to_string()
    |> String.pad_leading(5, "0")
    |> String.slice(-2, 2)

    if "99" == operation do
      state
    else
      state = process(state, operation)
      run(state)
    end
  end

  defp process(state, "01") do
    OpCodeParser.do_process(state, &(&1 + &2))
  end

  defp process(state, "02") do
    OpCodeParser.do_process(state, &(&1 * &2))
  end

  defp process(state, "03") do
    {input, _} = IO.gets("Input required: ") |> Integer.parse

    target_address = get_parameter(state, 1, true)

    state
    |> put_at(target_address, input)
    |> Map.put(:instruction_pointer, state.instruction_pointer + 2)
  end

  defp process(state, "04") do
    IO.puts(get_parameter(state, 1))

    Map.put(state, :instruction_pointer, state.instruction_pointer + 2)
  end

  defp process(state, "05") do
    conditional = get_parameter(state, 1)

    if conditional != 0 do
      jump_address = get_parameter(state, 2)
      Map.put(state, :instruction_pointer, jump_address)
    else
      Map.put(state, :instruction_pointer, state.instruction_pointer + 3)
    end
  end

  defp process(state, "06") do
    conditional = get_parameter(state, 1)

    if conditional == 0 do
      jump_address = get_parameter(state, 2)
      Map.put(state, :instruction_pointer, jump_address)
    else
      Map.put(state, :instruction_pointer, state.instruction_pointer + 3)
    end
  end

  defp process(state, "07") do
    first_val = get_parameter(state, 1)
    second_val = get_parameter(state, 2)

    store_value = if first_val < second_val, do: 1, else: 0

    write_target = get_parameter(state, 3, true)

    state
      |> put_at(write_target, store_value)
      |> Map.put(:instruction_pointer, state.instruction_pointer + 4)
  end

  defp process(state, "08") do
    first_val = get_parameter(state, 1)
    second_val = get_parameter(state, 2)

    store_value = if first_val == second_val, do: 1, else: 0

    write_target = get_parameter(state, 3, true)

    state
      |> put_at(write_target, store_value)
      |> Map.put(:instruction_pointer, state.instruction_pointer + 4)
  end

  def do_process(state, function) do
    a = get_parameter(state, 1)
    b = get_parameter(state, 2)

    target_index = get_parameter(state, 3, true)

    state =
      OpCodeParser.put_at(
        state,
        target_index,
        function.(a, b)
      )

    Map.put(state, :instruction_pointer, state.instruction_pointer + 4)
  end

  def get_parameter(state, n, write \\ false) do
    opcode = get_at(state, state.instruction_pointer)
    |> Integer.to_string()
    |> String.pad_leading(5, "0")

    mode = String.at(opcode, 3 - n)

    if !write and mode == "0" do
      target_index = get_at(state, state.instruction_pointer + n)
      get_at(state, target_index)
    else
      get_at(state, state.instruction_pointer + n)
    end
  end
end

initial_state = OpCodeParser.init("4,2,4,0,99")

initial_state =
  File.read!('../input.txt')
  |> String.trim()
  |> OpCodeParser.init()

IO.inspect(initial_state)

state = OpCodeParser.run(initial_state)

IO.inspect(state)
