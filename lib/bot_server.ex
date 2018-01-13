defmodule Bot.Server do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def cast(pid) do
    GenServer.cast(pid, :bot)
  end

  def handle_cast(:bot, state) do
    do_pool(state)
    {:noreply, state}
  end

  def do_pool(args) do
    %{update_id: update_id } = Bot.Worker.getUpdates(args)
    handle_cast(:bot, %{timeout: args[:timeout], update_id: update_id })
  end

end
