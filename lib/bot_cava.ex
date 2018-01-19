defmodule Bot.Cava do
  import Bot.Worker
  use Mailgun.Client,
    domain: Application.get_env(:bot, :mailgun_domain),
    key:    Application.get_env(:bot, :mailgun_key)


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

 def read_command(%{photo: [%{file_id: photo}, _, _, _], caption: "Отправить", chat: %{id: 415311574}}) do
   :dets.select(:user_of_cava, [{:"$1", [], [:"$1"]}])
   |>Enum.map(fn {id, _, _} -> cmd(:cava_nch, :sendPhoto, %{chat_id: id, photo: photo}) end)
 end

 def read_command(%{photo: [%{file_id: photo},  _, _], caption: "Отправить", chat: %{id: 415311574}}) do
   :dets.select(:user_of_cava, [{:"$1", [], [:"$1"]}])
   |>Enum.map(fn {id, _, _} -> cmd(:cava_nch, :sendPhoto, %{chat_id: id, photo: photo}) end)
 end

  def read_command(%{photo: [%{file_id: photo}, _, _, _], caption: caption, chat: %{id: 415311574}}) do
    :dets.insert(:menu, {caption, photo})
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

  def read_command(%{text: "Вернуться к чаям", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Выберете, пожалуйста, категорию", reply_markup: %{keyboard: Menu.Cava.tea(), one_time_keyboard: true } })

  def read_command(%{text: "Кофейная карта", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Здесь Вы можете увидеть имеющийся у нас ассортимент кофе и напитков на основе эспрессо", reply_markup: %{keyboard: Menu.Cava.coffee(), one_time_keyboard: false } })

  def read_command(%{text: "Чайная карта", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Здесь Вы можете увидеть имеющийся у нас ассортимент фирменного чая, приготавливаемого нашими баристами, а также чай от немецкой комании Ronniefildt", reply_markup: %{keyboard: Menu.Cava.tea(), one_time_keyboard: false } })

  def read_command(%{text: "Холодные напитки", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "В этой категории представлены холодные напитки, которыми можно утолить жажду в жаркий день или же побаловать себя", reply_markup: %{keyboard: Menu.Cava.cold(), one_time_keyboard: true } })

  def read_command(%{text: "Фирменные напитки", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Наш шеф-бариста подобрал для Вас лучшие комбинации на любой вкус, каждому найдется немного Coffee Cava", reply_markup: %{keyboard: Menu.Cava.firm(), one_time_keyboard: false } })

  def read_command(%{text: "Фирменные чаи", chat: %{id: id}}), do: 
  cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Наши фирменные чаи в чашках и чайниках", reply_markup: %{keyboard: Menu.Cava.firm_tea(), one_time_keyboard: false } })
  
  def read_command(%{text: "Чай Ronnenfeldt в чашке", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Здесь представлены чаи от немецкой компании Ronnenfeldt, подаваемые в чашке", reply_markup: %{keyboard: Menu.Cava.ron_tea_cup(), one_time_keyboard: false } })
  
    def read_command(%{text: "Чай Ronnenfeldt в чайнике", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Здесь ВЫ можете увидеть чай Ronnenfeldt, подаваемый в чайниках ", reply_markup: %{keyboard: Menu.Cava.ron_tea(), one_time_keyboard: false } })
    
    def read_command(%{text: "Десерты", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Наши десерты", reply_markup: %{keyboard: Menu.Cava.deserts(), one_time_keyboard: false } })
    
    def read_command(%{text: "Сендвичи и снеки", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Наши сытные и очень вкусные сендвичи и роллы", reply_markup: %{keyboard: Menu.Cava.snack(), one_time_keyboard: false } })
    
    def read_command(%{text: "Отправить сообщение разработчику", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Введите пожалуйста, текст сообщения в поле в формате \n Тема:Ваша_тема\nТекст: Ваш_текст"})

    def read_command(%{text: "Фирменные чаи", chat: %{id: id}}), do: 
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Ароматные, витаминные, незаменимые фирменные чаи", reply_markup: %{keyboard: Menu.Cava.firm_tea(), one_time_keyboard: false } })
    def read_command(%{text: text, chat: %{id: id},  from: %{first_name: name}}) do 
      file_id = :dets.match(:menu, {text, :"$1"})
      theme = ~r/Тема:/
      letter = ~r/Текст:/
      if file_id==[] do
        if text =~ theme && text =~ letter do
          send_letter(text)
        else
        cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Извините, #{name}, насчет этого вопроса я пока не могу Вам помочь, но чтобы ускорить процесс решения Вашей проблемы, Вы можете написать пользователю @papa_gusserl "})
        end
      else
        [[photo]] = file_id
        cmd(:cava_nch, :sendPhoto, %{chat_id: id, photo: photo})
      end
    end

    ###############
    # Private Box #
    ###############

     def  send_letter(text) do   
       IO.puts text
       send_email to: "akhtyamov.vlad@outlook.com",
             from: "vlad@papagusserl.com",
          subject: "Email from CavaBot",
       text: text 
     end
end
