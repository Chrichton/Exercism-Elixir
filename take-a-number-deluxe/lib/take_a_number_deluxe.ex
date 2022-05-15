defmodule TakeANumberDeluxe do
  # Client API
  use GenServer

  alias TakeANumberDeluxe.State

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    min_number = Keyword.get(init_arg, :min_number)
    max_number = Keyword.get(init_arg, :max_number)
    state = State.new(min_number, max_number)

    case state do
      {:ok, state} -> GenServer.start_link(TakeANumberDeluxe, state)
      error -> error
    end
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    # Please implement the reset_state/1 function
  end

  # Server callbacks
  @impl GenServer
  def init(init_arg) do
    state = init_arg
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:report_state, _from, state), do: {:reply, state, state}

  def handle_call(:queue_new_number, _from, state) do
    case State.queue_new_number(state) do
      {:ok, number, state} -> {:reply, {:ok, number}, state}
      error -> {:reply, error, state}
    end
  end

  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    case State.serve_next_queued_number(state, priority_number) do
      {:ok, number, state} -> {:reply, {:ok, number}, state}
      error -> {:reply, error, state}
    end
  end
end
