defmodule Cache do
  use GenServer

  def init(:ok) do
    {:ok, %{}}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, :ok)
  end

  def read(pid) do
    GenServer.call(pid, :read)
  end

  def read(pid, name) do
    GenServer.call(pid, {:read, name})
  end

  def write(pid, name, value) when is_atom(name) do
    GenServer.cast(pid, {:write, name, value})
  end

  def delete(pid, name) when is_atom(name) do
    GenServer.call(pid, {:delete, name})
  end

  def exists?(pid, name) when is_atom(name) do
    GenServer.call(pid, {:exists, name})
  end

  def clear(pid) do
    GenServer.cast(pid, :clear)
  end

  def handle_call(:read, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:read, name}, _from, state) do
    {:reply, Map.get(state, name), state}
  end

  def handle_call({:delete, name}, _from, state) do
    {:reply, Map.delete(state, name), state}
  end

  def handle_call({:exists, name}, _from, state) do
    {:reply, Map.has_key?(state, name), state}
  end

  def handle_cast(:clear, _state) do
    {:noreply, Map.new()}
  end

  def handle_cast({:write, name, value}, state) do
    {:noreply, Map.put(state, name, value)}
  end
end
