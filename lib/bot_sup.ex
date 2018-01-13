defmodule Bot do
  use Application

  def start(_type, _args) do
    Supervisor.start_link([
      {Bot.Supervisor, [%{update_id: 0, timeout: 500}]}
    ], strategy: :one_for_one)
  end

end
