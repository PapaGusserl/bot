defmodule Bot.Cava do
  import Bot.Worker
 
  def read_command(%{text: "/start", chat: %{id: id}, from: %{first_name: name, username: user}}) do
    cmd(:cava_nch, :sendMessage, %{chat_id: 415311574, text: "User #{name} with username #{user} join to Cava"})
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: Menu.Cava.start_message(), reply_markup: %{keyboard: Menu.Cava.rows() } })
    :dets.insert_new(:user_of_cava, {id, name, user})
  end 

  def read_command(%{text: _text, chat: %{id: id},  from: %{first_name: name}}), do: cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Извините, #{name}, насчет этого вопроса я пока не могу Вам помочь, но чтобы ускорить процесс решения Вашей проблемы, Вы можете написать пользователю @papa_gusserl "})
 
end
