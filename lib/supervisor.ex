defmodule Bot.Supervisor do
use Supervisor
 def start_link([:ok]) do
    :dets.open_file(:user_of_cava, [type: :set ])
    :dets.open_file(:menu, [type: :set])
    Supervisor.start_link([
      {Bot.Akhtyamov.Supervisor, [%{update_id: 0, timeout: 5000}]},
      {Bot.Cava.Supervisor, [%{update_id: 0, timeout: 50}]}
    ], strategy: :one_for_one)
  end

end
