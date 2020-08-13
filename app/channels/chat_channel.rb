class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "chat_#{params[:chat_id]}"
  end

  def unsubscribed
  end

  def receive(data)
    puts data
    # Currently, we dont actually use this code that much. But you would have to set up these models if you want to record the conversations in your chat.
    chat = Chat.find_or_create_by(id: params[:chat_id])
    new_message = Message.create(body: data["message"], user: User.find(data["user"]["user_id"]))
    chat.messages << new_message
    chat_key = chat.id

    messages_json = chat.messages.last(50).map do |message|
      chat_json = {
        "chat_key": chat_key,
        "message": message.body,
        "messageId": message.id,
        "user": message.user
      }
    end
    
    ActionCable.server.broadcast("chat_#{params[:chat_id]}", messages_json)
  end
end
