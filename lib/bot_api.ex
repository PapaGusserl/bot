defmodule Bot.API do
  alias Bot.Struc.Message
  alias Bot.Struc.Update
  alias Bot.Struc.User
  alias Bot.Struc.Callback

  def post(bot, method, opts) do
    url(bot, method)
    |> HTTPoison.post(request(opts), [], [timeout: timeout()])
    |> read_response(method)
   #|> parse(method)
  end

  defp url(bot, method)  do
    "https://api.telegram.org/bot#{token(bot)}/#{to_string(method)}"
  end

  defp token(bot) do
    ImpShit.token(bot)
 end

  defp timeout() do
    #
  end

  def request(opts) do
    opts = opts
           |> Map.update(:reply_markup, nil, &(Poison.encode!(&1)))  ## add to map 'opts' 'reply_markup: nil' and encode to json all values in opts
           |> Enum.filter(fn {_, v} -> v end)
           |> Enum.map(fn {k, v} -> {k, to_string(v)} end)
      {:form, opts}
  end

  defp read_response({:ok, %HTTPoison.Response{body: term, status_code: 200}}, method) do
    %{result: result} = term
      |> Poison.decode!(keys: :atoms)
    parse(result, method)
  end

  defp read_response({:error, %HTTPoison.Error{id: nil, reason: :timeout}}) do
    [%{error: "timeout"}]
   end

   def parse(result, method) do
     case method do
       :getUpdates -> 
         parse_value(:updates, result)
       :getMe ->
         parse_value(User, result)
       _ -> 
         parse_value(Message, result)
     end
   end

   def parse_value(:updates, result) do 
     Enum.map(result, &(parse_value(Update, &1)))
   end
   def parse_value(agent, result) do
     struct(agent, Enum.map(result, &(parse_value(&1))))    
   end
   def parse_value(%{callback_query: %{message: message}}) do
     parse_value(Message, message)
   end
   def parse_value(%{message: body}) do
     parse_value(Message, body)
   end
   def parse_value(%{chat: value}) do
     Enum.map(value, &(parse_value(&1)))
    end
   def parse_value(%{entities: value}) do
     Enum.map(value, &(parse_value(&1)))
    end
   def parse_value(%{from: value}) do
     Enum.map(value, &(parse_value(&1)))
   end  
   def parse_value(%{document: value}) do
     Enum.map(value, &(parse_value(&1)))
   end
   def parse_value(%{from: value}) do
     Enum.map(value, &(parse_value(&1)))
   end  
   def parse_value(tuple) do
      tuple
   end   
end

 
