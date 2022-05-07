defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    pid = spawn_link(fn -> calculator.(input) end)

    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, {%ArithmeticError{}, []}} -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  def reliability_check(calculator, inputs) do
    old_value = Process.flag(:trap_exit, true)

    result =
      Enum.reduce(inputs, Map.new(), fn input, acc ->
        %{pid: pid} = start_reliability_check(calculator, input)
        await_reliability_check_result(%{pid: pid, input: input}, acc)
      end)

    Process.flag(:trap_exit, old_value)

    result
  end

  def correctness_check(calculator, inputs) do
  end
end
