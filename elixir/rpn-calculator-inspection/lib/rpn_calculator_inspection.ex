defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    pid = spawn_link(fn -> calculator.(input) end)

    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, {%ArithmeticError{}, []}} -> Map.put(results, input, :error)
      {:EXIT, ^pid, _reason} -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  def reliability_check(calculator, inputs) do
    old_value = Process.flag(:trap_exit, true)

    result =
      inputs
      |> Enum.map(&start_reliability_check(calculator, &1))
      |> Enum.reduce(Map.new(), fn %{pid: pid, input: input}, acc ->
        await_reliability_check_result(%{pid: pid, input: input}, acc)
      end)

    Process.flag(:trap_exit, old_value)

    result
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Task.await_many(100)
  end
end
