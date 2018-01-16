defmodule Bot do
  use Application
  use Supervisor
  def start(_type, _args) do
    Supervisor.start_link([
      {Bot.Supervisor, [:ok]}
    ], strategy: :one_for_one)
  end

end
