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
    :noreply
  end
    
end
