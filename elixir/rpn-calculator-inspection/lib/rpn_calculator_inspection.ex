defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    pid = spawn_link(fn -> calculator.(input) end)

    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
  end

  def reliability_check(calculator, inputs) do
  end

  def correctness_check(calculator, inputs) do
  end
end
