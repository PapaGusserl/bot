defmodule Bot.Cava.Supervisor do
  use Supervisor

  def start_link([args]) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init(args) do
    Supervisor.init([
                     {Bot.Cava.Server, args}
                                     ], strategy: :one_for_one)
  end

end
