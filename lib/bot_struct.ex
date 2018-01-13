defmodule Bot.Struc do
defmodule Message do
      defstruct message_id: nil, from: nil, date: nil, chat: nil, forward_from: nil,
        forward_from_chat: nil, forward_date: nil, reply_to_message: nil, edit_date: nil,
        text: nil, entities: nil, audio: nil, document: nil, photo: [], sticker: nil, video: nil,
        voice: nil, caption: nil, contact: nil, location: nil, venue: nil, new_chat_member: nil,
        left_chat_member: nil, new_chat_title: nil, new_chat_photo: [], delete_chat_photo: nil,
        group_chat_created: nil, supergroup_chat_created: nil, channel_chat_created: nil,
        migrate_to_chat_id: nil, migrate_from_chat_id: nil, pinned_message: nil
    end

defmodule User do
  defstruct id: nil, is_bot: nil, first_name: nil, last_name: nil, username: nil, language_code: nil
end
  defmodule Update do
    defstruct update_id: nil, message: %Bot.Struc.Message{}
  end
end
