require IntcodeComputer

initial_state =
  File.read!("input.txt")
  |> String.trim()
  |> IntcodeComputer.init()

IO.inspect(initial_state)

state = IntcodeComputer.run(initial_state)

IO.inspect(state)
