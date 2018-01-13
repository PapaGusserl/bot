defmodule Bot.Supervisor do
  use Supervisor

  def start_link([args]) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init(args) do
    Supervisor.init([
                                      {Bot.Server, args}
                                     ], strategy: :one_for_one)
  end

  def cast(sup_pid) do
    {_, worker_pid, _, _} = Supervisor.which_children(sup_pid)
                            |> Enum.find( fn {x, _, _, _} -> x == Bot.Server end )
    Bot.Server.cast(worker_pid)
  end

end
