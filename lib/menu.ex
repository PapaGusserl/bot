defmodule Menu do

  def rows do
    [
      [%{text: "Button 1"}, %{text: "Button 2"}, %{text: "Button 3"}],
      [%{text: "Button 4"}, %{text: "Button 5"}, %{text: "Button 6"}],
      [%{text: "Button 7"}, %{text: "Button 8"}, %{text: "Button 9"}],
      [%{text: "Button *"}, %{text: "Button 0"}, %{text: "Button #"}],
    ]
  end

  def start_message do
    "Hello, Dear friend! Welcome to beta-beta bot!"
  end

end  
