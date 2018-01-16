defmodule Menu.Cava do

  def rows do
    [
      [%{text: "Меню"}],
      [%{text: "Оставить отзыв"}],
      [%{text: "Сделать заказ в офис"}]
    ]
  end

  def start_message do
    "Hello, Dear friend! Welcome to beta-beta bot! If I do all wright, then you be my patient"
  end

end  
