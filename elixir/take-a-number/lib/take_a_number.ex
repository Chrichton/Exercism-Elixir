defmodule TakeANumber do
  def loop(counter \\ 0) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, counter)
        loop(counter)

      {:take_a_number, sender_pid} ->
        counter = counter + 1
        send(sender_pid, counter)
        loop(counter)

      :stop ->
        counter

      _ ->
        loop(counter)
    end
  end

  def start() do
    spawn(&loop/0)
  end
end
