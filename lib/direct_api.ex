defmodule Bot.Dist.API do

  def url(origin, destination), do: "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=#{URI.encode(origin)}&destinations=#{URI.encode(destination)}&key=#{token()}&mode=walking"
  
  def token, do: "AIzaSyD61HCrRgYPJtjuU1kqsybttpwlFXCgFY0"

  def get(origin, destination) do
    url(origin, destination)
    |> HTTPoison.get
    |> parse
  end

  def parse({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    %{rows: [%{elements: [%{distance: %{text: dist}}, %{distance: %{text: dist2}}]}]} = Poison.decode!(body, keys: :atoms)
    %{it: dist, centr: dist2}
  end

end
