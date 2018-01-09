defmodule Bot.API do

  def post(method, opts) do
    url()
    |> <> URI.encode(method)
    |> HTTPoison.post(request(opts), [], [timeout: timeout()])
    |> read_response
  end

  defp url() do
    #
  end

  defp timeout() do
    #
  end

  defp request(opts) do
    #
    {:form, opts}
  end

  defp read_response(%HTTPoison.Response{body: term, headers: list, request_url: term, status_code: 200}) do
    #
  end

   defp read_response(%HTTPoison.Response{body: term, headers: list, request_url: term, status_code: 404}) do
    #
  end
  
