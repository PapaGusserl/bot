defmodule Bot.Akhtyamov do
  import Bot.Worker

  def read_command(%{text: "/start", chat: %{id: id}, from: %{first_name: name, username: user}}) do
    cmd(:akhtyamov, :sendMessage, %{chat_id: 415311574, text: "User #{name} with username #{user} join to Akhtyamov Bot"})
    cmd(:akhtyamov, :sendMessage, %{chat_id: id, text: Menu.Akhtyamov.start_message(), reply_markup: %{keyboard: Menu.Akhtyamov.rows() } })
  end 
 
  def read_command(%{text: "/whoami", chat: %{id: id}, from: %{is_bot: bool, first_name: name, username: user}}), do: cmd(:akhtyamov, :sendMessage, %{text: "Hello, #{name}. I'm really happy to see you. Remeber, that you id: #{id} and username is #{user}. Press /hello, if you want, that I must to say 'Hello, world'", chat_id: id})
 
  def read_command(%{text: "/hello", chat: %{id: id}}), do: cmd(:akhtyamov, :sendMessage, %{text: "Hello, world!", chat_id: id})
 
  def read_command(%{text: text, chat: %{id: id}, from: %{first_name: name}}), do: cmd(:akhtyamov, :sendMessage, %{text: "#{name}, не пишите хуйню.\"#{text}\" - хуйня", chat_id: id})

end     
