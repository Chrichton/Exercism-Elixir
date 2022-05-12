defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  use Timex

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    Agent.start_link(fn -> {Map.new(), capacity} end)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    Agent.get(buffer, fn {map, _capacity} ->
      if Enum.empty?(map) do
        {:error, :empty}
      else
        map
        |> Map.to_list()
        |> Enum.sort_by(fn {key, _} -> key end, {:asc, Timex})
        |> List.first()
      end
    end)
    |> case do
      {:error, :empty} ->
        {:error, :empty}

      {key, value} ->
        remove_key(buffer, key)
        {:ok, value}
    end
  end

  defp remove_key(buffer, key) do
    Agent.update(buffer, fn {map, capacity} ->
      {Map.delete(map, key), capacity}
    end)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    if full?(buffer) do
      {:error, :full}
    else
      Agent.update(buffer, fn {map, capacity} ->
        map = Map.put(map, Timex.now(), item)

        {map, capacity}
      end)
    end
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
  end

  defp full?(buffer) do
    Agent.get(buffer, fn {map, capacity} ->
      Enum.count(map) == capacity
    end)
  end
end
