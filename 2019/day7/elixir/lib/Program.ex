defmodule Program do
  use Application

  def start(_type, _args) do
    input = File.read!("../input.txt")

    max = find_max(input)

    IO.puts("Max: #{max}")

    {:ok, self()}
  end

  def find_max(op_codes) do
    range = 5..9

    for n <- range do
      for o <- range, !Enum.member?([n], o) do
        for p <- range, !Enum.member?([n, o], p) do
          for q <- range, !Enum.member?([n, o, p], q) do
            for r <- range, !Enum.member?([n, o, p, q], r) do
              # IO.inspect({n, o, p, q, r})
              try_combination(op_codes, [n, o, p, q, r])
            end
          end
        end
      end
    end
    |> List.flatten()
    |> Enum.max()
  end

  def try_combination(op_codes, phase_settings) do
    extended_phase_settings =
      Enum.map(
        phase_settings,
        &%{
          phase_setting: &1,
          last_out: 0
        }
      )

    intcode_inputs = %{
      current_input: 0,
      phase_inputs: extended_phase_settings,
      get_phase_output: fn intcode_inputs ->
        Enum.at(
          intcode_inputs.phase_inputs,
          intcode_inputs.current_input
        )
      end,
      update_to_next_phase: fn intcode_inputs ->
        Map.update!(
          intcode_inputs,
          :current_input,
          &rem(&1 + 1, 5)
        )
      end,
      insert_output: fn intcode_inputs, last_out ->
        Map.update!(intcode_inputs, :phase_inputs, fn phase_settings ->
          List.update_at(phase_settings, intcode_inputs.current_input, fn %{
                                                                            phase_setting: s,
                                                                            last_out: _
                                                                          } ->
            %{
              phase_setting: s,
              last_out: last_out
            }
          end)
        end)
      end
    }

    resulting_state =
      IntcodeComputer.init(op_codes, intcode_inputs)
      |> IntcodeComputer.run()

    output = Map.get(resulting_state, :output_value)

    if IntcodeComputer.finished?(resulting_state) do
      output
    else
      try_combination(
        op_codes,
        resulting_state
      )
    end
  end
end
