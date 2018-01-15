defmodule Bot.Akhtyamov.Server do
  use GenServer

  def start_link(args) do
    {:ok, pid} = GenServer.start_link(__MODULE__, args)
    cast(pid)
    {:ok, pid}
  end

  def cast(pid) do
    GenServer.cast(pid, :bot)
  end

  def handle_cast(:bot, state) do
    do_pool(state)
    {:noreply, state}
  end

  def do_pool(args) do
    %{update_id: update_id } = Bot.Worker.getUpdates(:akhtyamov, args)
    handle_cast(:bot, %{timeout: args[:timeout], update_id: update_id })
  end

end
