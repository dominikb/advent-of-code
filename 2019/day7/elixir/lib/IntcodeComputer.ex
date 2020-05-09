defmodule IntcodeComputer do
  def init(raw_opcodes, input_values) do
    opcodes =
      raw_opcodes
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    %{
      instruction_pointer: 0,
      opcodes: opcodes,
      output_value: 0,
      inputs: input_values,
      stopped: false
    }
  end

  def get_at(state, index) do
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
    operation =
      get_at(state, state.instruction_pointer)
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> String.slice(-2, 2)

    if "99" == operation do
      Map.put(state, :stopped, true)
    else
      state = process(state, operation)
      Map.put(state, :inputs, state.inputs.update_to_next_phase.(state.inputs)) |> run()
    end
  end

  def finished?(state), do: state.stopped

  defp process(state, "01"), do: do_process(state, &(&1 + &2))

  defp process(state, "02"), do: do_process(state, &(&1 * &2))

  defp process(state, "03") do
    case state.inputs.get_phase_output.(state.inputs) do
      :error ->
        state
        |> Map.put(:output_value, 0)
        |> Map.put(:stopped, true)

      %{last_out: value, phase_setting: _phase_setting} ->
        target_address = get_parameter(state, 1, true)

        state
        |> put_at(target_address, value)
        |> Map.put(:instruction_pointer, state.instruction_pointer + 2)
    end
  end

  defp process(state, "04") do
    value = get_parameter(state, 1)

    # IO.puts("Output: #{value}")

    state
    |> Map.put(:output_value, value)
    |> Map.put(:instruction_pointer, state.instruction_pointer + 2)
    |> Map.put(:inputs, state.inputs.insert_output.(state.inputs, value))
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
      put_at(
        state,
        target_index,
        function.(a, b)
      )

    Map.put(state, :instruction_pointer, state.instruction_pointer + 4)
  end

  def get_parameter(state, n, write \\ false) do
    opcode =
      get_at(state, state.instruction_pointer)
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
