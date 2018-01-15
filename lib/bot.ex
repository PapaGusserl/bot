defmodule Bot.Worker do

  def getUpdates(bot, %{update_id: offset, timeout: timeout}) do
    %{update_id: update_id} = cmd(bot, :getUpdates, %{offset: offset, timeout: timeout})
    %{update_id: update_id+1, timeout: timeout}
  end

  def cmd(bot, method, args) do
    Bot.API.post(bot, method, args) 
    |> bot_funcs(bot)
  end

  def bot_funcs([job], bot) do
    bot_func(job, bot)
    job
  end
  
  def bot_funcs([job | _tail], bot) do
    bot_func(job, bot)
  end

  def bot_funcs(job, bot), do: bot_func(job, bot)

  def bot_func(job, bot) do
    case job do
      %{message: message, update_id: update_id} -> 
        Bot.API.parse(message, Message)
        |> commands_of(bot)
        %{update_id: update_id}
      _ -> :request
      end
  end

  def commands_of(body, bot) do
    case bot do
      :akhtyamov -> Bot.Akhtyamov.read_command(body)
      :cava_nch -> Bot.Cava.read_command(body)
    end
  end

end
