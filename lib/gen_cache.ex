defmodule Citibike.GenCache do
  @moduledoc """
  Generic LRU Cache that invalidates base off of two strategies:

  ## Strategies

    - `max_items`: If the number of items in the cache exceeds a configured amount, invalidate the
    LRU items

    - `max_bytes`: If the total byte count in the cache exceeds a configured amount, invalidate the
    LRU items

  """

  use GenServer


  ###################################################################################
  # Public API
  ###################################################################################

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end


  def push(key, value) do
    GenServer.cast(__MODULE__, {:push, key, value})
  end


  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end


  def touch(key) do
    GenServer.call(__MODULE__, {:touch, key})
  end


  def empty do
    GenServer.cast(__MODULE__, {:empty})
  end


  def items do
    GenServer.call(__MODULE__, {:items})
  end


  def full? do
    GenServer.call(__MODULE__, {:full?})
  end


  ###################################################################################
  # Server
  ###################################################################################

  def init(opts) do
    strategy =
      resolve_strategy(opts)

    state = %{
      strategy: strategy,
      limit: opts[:max_items] || opts[:max_bytes],
      items: %{}, # stores the items indexed by their keys
      lru: [], # stores the keys of the LRU'd items
    }

    {:ok, state}
  end


  def handle_cast({:push, key, value}, state) do
    state =
      %{state |
        items: Map.put(state.items, key, value),
        lru: [key | state.lru],
       }

    {:noreply, state}
  end


  def handle_cast({:empty}, state) do
    state =
      %{state |
        items: %{},
        lru: [],
       }

    {:noreply, state}
  end


  def handle_cast({:touch, key}, state) do
    state =
      %{state | lru: to_front(key, state.lru)}

    {:noreply, state}
  end


  def handle_call({:get, key}, _fr, state) do
    state =
      %{state |
        lru: [],
       }

    {:reply, Map.get(state, key), state}
  end


  def handle_call({:items}, _fr, state) do
    items =
      state.lru
      |> Stream.map(fn k -> {k, Map.get(state.items, k)} end)
      |> Enum.into([])

    {:reply, items, state}
  end


  def handle_call({:full?}, _fr, state) do
    result =
      case state.strategy do
        :max_items ->
          Enum.count(state.items) == state.limit

        _ ->
          raise("Not impl'd")
      end

    {:reply, result, state}
  end


  ###################################################################################
  # Private Helpers
  ###################################################################################

  @spec to_front(any, [any]) :: [any]
  defp to_front(key, list) do
    case Enum.member?(list, key) do
      true  ->
        removed =
          list |> List.delete(key)

        [key | removed]

      false ->
        [key | list]
    end
  end


  defp resolve_strategy(max_items: nil, max_bytes: nil),
    do: raise(ArgumentError, "No strategy provided")

  defp resolve_strategy(max_items: _), do: :max_items
  defp resolve_strategy(max_bytes: _), do: :max_bytes

end
