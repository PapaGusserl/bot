defmodule Bot.Worker do

  def getUpdates(%{update_id: offset, timeout: timeout) do
    cmd("getUpdates", %{offset: offset, timeout: timeout}
    %{update_id: update_id, timeout: timeout}
  end

end
