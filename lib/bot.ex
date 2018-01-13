defmodule Bot.Worker do

  def getUpdates(%{update_id: offset, timeout: timeout}) do
    cmd("getUpdates", %{offset: offset, timeout: timeout})
    %{update_id: offset, timeout: timeout}
  end

  def cmd(method, args) do
    Bot.API.post(method, args) 
    |> process_jobs
  end

  def process_jobs([job]) do
    process_job(job)
    job
  end
  
  def process_jobs([job | tail]) do
    process_job(job)
  end

  def process_job(job) do
    Bot.Api.parse(:decod, job)
    |> read_command
  end

  def read_command(%{text: "/start", id: id}), do: cmd(:sendMessage, %{chat_id: id, text: Menu.start_message(), reply_markup: %{keyboard: Menu.rows() } }, end

  def read_command(%{text: "/hello", id: id}), do: cmd(:sendMessage, %{text: "Hello, world!", chat_id: id}), end

    
    
end
