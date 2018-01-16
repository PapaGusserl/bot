defmodule Bot.Cava do
  import Bot.Worker
 
  def read_command(%{text: "/start", chat: %{id: id}, from: %{first_name: name, username: user}}) do
    cmd(:cava_nch, :sendMessage, %{chat_id: 415311574, text: "User #{name} with username #{user} join to Cava"})
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: Menu.Cava.start_message(), reply_markup: %{keyboard: Menu.Cava.rows() } })
    :dets.insert_new(:user_of_cava, {id, name, user})
  end 
 
  def read_command(%{text: "/start", chat: %{id: id}, from: %{first_name: name}}) do
    cmd(:cava_nch, :sendMessage, %{chat_id: 415311574, text: "User #{name} with-out username join to Cava"})
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: Menu.Cava.start_message(), reply_markup: %{keyboard: Menu.Cava.rows() } })
    :dets.insert_new(:user_of_cava, {id, name, :no})
  end 

  def read_command(%{type: photo, media: file_id, chat: %{id: 415311574}}) do
    IO.puts "Photo"
    :dets.select(:user_of_cava, [{:"$1", [], [:"$1"]}])
    |>Enum.map(fn {id, _, _} -> cmd(:cava_nch, :sendPhoto, %{chat_id: id, type: photo, media: file_id}) end)
  end

def read_command(%{text: text, chat: %{id: 415311574}}) do
    :dets.select(:user_of_cava, [{:"$1", [], [:"$1"]}])
    |>Enum.map(fn {id, _, _} -> cmd(:cava_nch, :sendMessage, %{chat_id: id, text: text}) end)
  end
  
  def read_command(%{text: _text, chat: %{id: id},  from: %{first_name: name}}), do: cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Извините, #{name}, насчет этого вопроса я пока не могу Вам помочь, но чтобы ускорить процесс решения Вашей проблемы, Вы можете написать пользователю @papa_gusserl "})
 
end
