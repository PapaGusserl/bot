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
    :dets.insert_new(:user_of_cava, {id, name, user, %{bookmarks: ["Закладки:\n"]}, %{history: ["Вернуться домой"]}})
  end 
 
  def read_command(%{text: "/start", chat: %{id: id}, from: %{first_name: name}}) do
    cmd(:cava_nch, :sendMessage, %{chat_id: 415311574, text: "User #{name} with-out username join to Cava"})
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: Menu.Cava.start_message(), reply_markup: %{keyboard: Menu.Cava.rows() } })
    :dets.insert_new(:user_of_cava, {id, name, "no-username", %{bookmarks: ["Закладки:\n"]}, %{history: ["Вернуться домой"]}})
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
  
  def read_command(%{location: %{latitude: lat, longitude: long}, chat: %{id: id}}) do
    {how_much, where} = find_cava("#{lat},#{long}")
    cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Пожалуйста, направляйтесь в #{where}, до кофейни осталось #{how_much}"})
  end

  def read_command(%{text: text, chat: %{id: id}}, after_back \\ false) do
    [[name, user, %{bookmarks: bookmarks}, %{history: history }]] = :dets.match(:user_of_cava, {id , :"$1", :"$2", :"$3", :"$4"})
    if text == "Назад" do
      history = List.delete_at(history, Enum.count(history) - 1)
      :dets.insert(:user_of_cava, {id, name, user, %{bookmarks: bookmarks}, %{history: history}})
      read_command(%{text: List.last(history), chat: %{id: id}}, true)
    else
      [h|t] = history
      history = if Enum.count(history) > 10, do: t, else: history
      unless after_back, do: :dets.insert(:user_of_cava, {id, name, user, %{bookmarks: bookmarks}, %{history: history ++ [text]}})
      case text do
        "Меню"                              -> command(id, "Выберете, пожалуйста, категорию", Menu.Cava.kategories())
        "Вернуться домой"                   -> command(id, "Выберете, пожалуйста, категорию", Menu.Cava.rows())
        "Кофейная карта"                    -> command(id, "Здесь Вы можете увидеть имеющийся у нас ассортимент кофе и напитков на основе эспрессо", Menu.Cava.coffee())
        "😋Акции"                           -> command(id, "Наши акции", Menu.Cava.discounts())
        "Оставить отзыв"                    -> command(id, "Пожалуйста, введите свой отзыв в формате \"Отзыв: Ваш отзыв\"", Menu.Cava.rows())
        "Чайная карта"                      -> command(id, "Наши чаи", Menu.Cava.tea())
        "Вернуться к чаям"                  -> command(id, "Наши чаи", Menu.Cava.tea())
        "Закладки"                          -> command(id, "#{inspect bookmarks }", Menu.Cava.rows())
        "Фирменные напитки"                 -> command(id, "Фирменные напитки Coffee Cava", Menu.Cava.firm())
        "Фирменный чай"                     -> command(id, "Фирменные чаи", Menu.Cava.firm_tea())
        "Десерты"                           -> command(id, "Наши десерты", Menu.Cava.deserts())
        "Холодные напитки"                  -> command(id, "Наши холодные напитки", Menu.Cava.cold())
        "Сендвичи и снеки"                  -> command(id, "Сытные и легкие сендвичи на любой вкус", Menu.Cava.snack())
        "Чай Ronnenfeldt в чайнике"         -> command(id, "Ароматные немецкие чаи", Menu.Cava.ron_tea())
        "Чай Ronnenfeldt в чашке"           -> command(id, "Ароматные немецкие чаи", Menu.Cava.ron_tea_cup())
        "Отправить сообщение разработчику"  -> command(id, "Введите пожалуйста, текст сообщения в поле в формате \n Тема:Ваша_тема\nТекст: Ваш_текст", Menu.Cava.rows())
        "В закладки"                        -> :dets.insert(:user_of_cava, {id, name, user, %{bookmarks: bookmarks ++ [List.last(history)]}, %{history: history}})
                                             command(id, "Позиция добавлена в Ваши закладки", Menu.Cava.funcs())
        _                                   -> 
          file_id = :dets.match(:menu, {text, :"$1"})
          theme = ~r/Тема:/
          recens = ~r/Отзыв:/
          letter = ~r/Текст:/
          if file_id==[] do
            if text =~ theme && text =~ letter do
              send_letter(text)
              cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Ваше письмо отправлено!"})
            else
              if text =~ recens do
                cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Большое спасибо за Ваш отзыв"})
                cmd(:cava_nch, :sendMessage, %{chat_id: 415311574, text: "User #{user} write:\n #{text}"})
              else
                cmd(:cava_nch, :sendMessage, %{chat_id: id, text: "Извините, #{name}, насчет этого вопроса я пока не могу Вам помочь, но чтобы ускорить процесс решения Вашей проблемы, Вы можете написать пользователю @papa_gusserl "})
              end
            end
          else
            [[photo]] = file_id
            cmd(:cava_nch, :sendPhoto, %{chat_id: id, photo: photo, reply_markup: %{keyboard: Menu.Cava.funcs()}})
          end
      end
    end   
  end

  def command(id, text, keyboard), do: cmd(:cava_nch, :sendMessage, %{chat_id: id, text: text, reply_markup: %{keyboard: keyboard}})

    

    ###############
    # Private Box #
    ###############

     def  send_letter(text), do:   
       send_email to: "akhtyamov.vlad@outlook.com",
                from: "vlad@papagusserl.com",
             subject: "Email from CavaBot",
                text: text 

     def find_cava(lng) do
       it_park_chelny = "55.738447,52.450314"
       sity_centr = "55.741005,52.414335"
       objects = it_park_chelny <> "|" <> sity_centr
       %{it: dist, centr: dist2} = Bot.Dist.API.get(lng, objects) 
       {it, _} = Float.parse(dist)
       {centr, _} = Float.parse(dist2)
       if it < centr do
         {dist, "ИТ парк, Корпус А, 1 этаж"}
       else
         {dist2, "Бизнес Центр 2/18, Корпус Б, 1 этаж"}
       end
     end

end

