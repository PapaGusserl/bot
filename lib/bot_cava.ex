defmodule Bot.Cava do
  import Bot.Worker

  ##################
  # Start commands #
  ##################
 
  def read_command(%{text: "/start", chat: %{id: id}, from: %{first_name: name, username: user}}) do
    cmd(:cava_nch, :sendMessage, %{chat_id: 415311574, text: "User #{name} with username #{user} join to Cava"})
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: Menu.Cava.start_message(), reply_markup: %{keyboard: Menu.Cava.rows(), one_time_keyboard: false } })
    :dets.insert_new(:user_of_cava, {id, name, user})
  end 
 
  def read_command(%{text: "/start", chat: %{id: id}, from: %{first_name: name}}) do
    cmd(:cava_nch, :sendMessage, %{chat_id: 415311574, text: "User #{name} with-out username join to Cava"})
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: Menu.Cava.start_message(), reply_markup: %{keyboard: Menu.Cava.rows() } })
    :dets.insert_new(:user_of_cava, {id, name, :no})
  end 

  ####################
  # Admin's commands #
  ####################

  def read_command(%{photo: [%{file_id: photo}, _, _, _], caption: caption, chat: %{id: 415311574}}) do
    :dets.insert(:menu, {caption, photo})
  end
 
 def read_command(%{photo: [%{file_id: photo}, _, _, _], caption: "Отправить", chat: %{id: 415311574}}) do
   :dets.select(:user_of_cava, [{:"$1", [], [:"$1"]}])
   |>Enum.map(fn {id, _, _} -> cmd(:cava_nch, :sendPhoto, %{chat_id: id, photo: photo}) end)
 end

  def read_command(%{text: text, chat: %{id: 415311574}}) do
    :dets.select(:user_of_cava, [{:"$1", [], [:"$1"]}])
    |>Enum.map(fn {id, _, _} -> cmd(:cava_nch, :sendMessage, %{chat_id: id, text: text}) end)
  end

 
  ###################
  # User's commands #
  ###################

  #def read_command(%{text: ""}), do:
  #def read_command(%{text: "", from: %{first_name: name}}), do:
  
  def read_command(%{text: "Меню", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Выберете, пожалуйста, категорию", reply_markup: %{keyboard: Menu.Cava.kategories(), one_time_keyboard: true } })

  def read_command(%{text: "Вернуться домой", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Вы вернулись в основное меню", reply_markup: %{keyboard: Menu.Cava.rows(), one_time_keyboard: false } })

  def read_command(%{text: "Кофейная карта", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Здесь Вы можете увидеть имеющийся у нас ассортимент кофе и напитков на основе эспрессо", reply_markup: %{keyboard: Menu.Cava.coffee(), one_time_keyboard: false } })

  def read_command(%{text: "Чайная карта", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Здесь Вы можете увидеть имеющийся у нас ассортимент фирменного чая, приготавливаемого нашими баристами, а также чай от немецкой комании Ronniefildt", reply_markup: %{keyboard: Menu.Cava.tea(), one_time_keyboard: false } })

  def read_command(%{text: "Холодные напитки", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "В этой категории представлены холодные напитки, которыми можно утолить жажду в жаркий день или же побаловать себя", reply_markup: %{keyboard: Menu.Cava.cold(), one_time_keyboard: true } })

  def read_command(%{text: "Фирменные напитки", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Наш шеф-бариста подобрал для Вас лучшие комбинации на любой вкус, каждому найдется немного Coffee Cava", reply_markup: %{keyboard: Menu.Cava.firm(), one_time_keyboard: false } })

    def read_command(%{text: text, chat: %{id: id},  from: %{first_name: name}}) do 
      file_id = :dets.match(:menu, {text, :"$1"})
      if file_id==[] do
         cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Извините, #{name}, насчет этого вопроса я пока не могу Вам помочь, но чтобы ускорить процесс решения Вашей проблемы, Вы можете написать пользователю @papa_gusserl "})
      else
        [[photo]] = file_id
        cmd(:cava_nch, :sendPhoto, %{chat_id: id, photo: photo})
      end
    end
end
