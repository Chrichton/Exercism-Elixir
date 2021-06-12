defmodule BankAccount do
  use GenServer

  @impl true
  @spec init([Posting.t()]) :: {:ok, [Posting.t()]}
  def init(postings) do
    {:ok, postings}
  end

  @impl true
  def handle_call(:balance, _from, postings) do
    balance = Enum.reduce(postings, 0, fn posting, acc -> posting.amount + acc end)

    {:reply, balance, postings}
  end

  @impl true
  def handle_cast({:update, posting}, postings) do
    {:noreply, [posting | postings]}
  end

  defmodule Posting do
    @enforce_keys [:amount, :date_time]
    defstruct amount: nil, date_time: nil
    @type t :: %__MODULE__{amount: integer(), date_time: DateTime.t()}
  end

  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    GenServer.stop(account, :normal)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    if Process.alive?(account),
      do: GenServer.call(account, :balance),
      else: {:error, :account_closed}
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    if Process.alive?(account),
      do:
        GenServer.cast(
          account,
          {:update, %Posting{amount: amount, date_time: DateTime.utc_now()}}
        ),
      else: {:error, :account_closed}
  end
end
