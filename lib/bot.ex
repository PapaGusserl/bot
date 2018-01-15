defmodule Bot.Worker do

  def getUpdates(%{update_id: offset, timeout: timeout}) do
    %{update_id: update_id} = cmd(:getUpdates, %{offset: offset, timeout: timeout})
    %{update_id: update_id+1, timeout: timeout}
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

  def process_jobs(job), do: process_job(job)

  def process_job(job) do
    case job do
      %{message: message, update_id: update_id} -> 
        Bot.API.parse(message, Message)
        |> read_command
        IO.puts "#{update_id}"
        %{update_id: update_id}
      _ -> :request
      end
  end

  def read_command(%{text: "/start", chat: %{id: id}, from: %{first_name: name, username: user}}) do
    cmd(:sendMessage, %{chat_id: 415311574, text: "User #{name} with username #{user} join to our Bot"})
    cmd(:sendMessage, %{chat_id: id, text: Menu.start_message(), reply_markup: %{keyboard: Menu.rows() } })
  end 
  def read_command(%{text: "/whoami", chat: %{id: id}, from: %{is_bot: bool, first_name: name, username: user}}), do: cmd(:sendMessage, %{text: "Hello, #{name}. I'm really happy to see you. Remeber, that you id: #{id} and username is #{user}. Press /hello, if you want, that I must to say 'Hello, world'", chat_id: id})
  def read_command(%{text: "/hello", chat: %{id: id}}), do: cmd(:sendMessage, %{text: "Hello, world!", chat_id: id})
  def read_command(%{text: text, chat: %{id: id}, from: %{first_name: name}}), do: cmd(:sendMessage, %{text: "#{name}, не пишите хуйню.\"#{text}\" - хуйня", chat_id: id})
end
