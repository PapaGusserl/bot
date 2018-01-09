defmodule Bot.API do

  def post(method, opts) do
    url()
    |> <> URI.encode(method)
    |> HTTPoison.post(request(opts), [], [timeout: timeout()])
    |> read_response
    |> parse(method)
  end

  defp url() do
    #
  end

  defp timeout() do
    #
  end

  defp request(opts) do
    opts = opts
           |> Map.update(:reply_markup, nil, &(Poison.encode!(&1)))
           |> Enum.filter_map(fn {_, v} -> v end, fn {k, v} -> {k, to_string(v)} end)
      {:form, opts}
  end

  defp read_response(%HTTPoison.Response{body: term, headers: list, request_url: term, status_code: 200}) do
    %{result: result} =
      term
      |> Poison.decode!(keys: :atoms)
    result
  end

   defp read_response(%HTTPoison.Response{body: term, headers: list, request_url: term, status_code: 404}) do
    #
   end

   def parse(result, method) do
     case method do
       "getUpdates" -> 
         parse_value(:updates, result)
       "getMe" ->
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

   def parse_value({key, value}) do
     {key, Enum.map(value, &(parse_value(&1)))}
   end

end  
