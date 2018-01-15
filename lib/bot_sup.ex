defmodule Bot do
  use Application

  def start(_type, _args) do
    :dets.open_file(:user_of_cava, [type: :set ])
    Supervisor.start_link([
      {Bot.Akhtyamov.Supervisor, [%{update_id: 0, timeout: 5000}]},
      {Bot.Cava.Supervisor, [%{update_id: 0, timeout: 5000}]}
    ], strategy: :one_for_one)
  end

end
