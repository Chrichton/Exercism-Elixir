defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    Agent.start_link(fn -> initial_state(capacity) end)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    Agent.get(buffer, fn {map, _capacity} ->
      if Enum.empty?(map),
        do: {:error, :empty},
        else: get_oldest_item(map)
    end)
    |> case do
      {:error, :empty} ->
        {:error, :empty}

      {key, value} ->
        remove_item(buffer, {key, value})
        {:ok, value}
    end
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    if full?(buffer),
      do: {:error, :full},
      else: add_item(buffer, item)
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    if full?(buffer),
      do: replace_oldest_item(buffer, item),
      else: add_item(buffer, item)
  end

  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    Agent.update(buffer, fn {_map, capacity} ->
      initial_state(capacity)
    end)
  end

  defp add_item(buffer, item) do
    Agent.update(buffer, fn {map, capacity} ->
      {add_item_to_map(map, item), capacity}
    end)
  end

  def replace_oldest_item(buffer, item) do
    Agent.update(buffer, fn {map, capacity} ->
      {key, _value} = get_oldest_item(map)

      map
      |> Map.delete(key)
      |> add_item_to_map(item)
      |> then(fn map -> {map, capacity} end)
    end)
  end

  defp remove_item(buffer, {key, _value}) do
    Agent.update(buffer, fn {map, capacity} ->
      {Map.delete(map, key), capacity}
    end)
  end

  defp get_oldest_item(map) do
    map
    |> Map.to_list()
    |> Enum.sort_by(fn {key, _} -> key end)
    |> List.first()
  end

  defp add_item_to_map(map, item), do: Map.put(map, :erlang.system_time(), item)

  defp full?(buffer) do
    Agent.get(buffer, fn {map, capacity} ->
      Enum.count(map) == capacity
    end)
  end

  defp initial_state(capacity), do: {Map.new(), capacity}
end
