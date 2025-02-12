class GiftsController < Controller
    def new_gift(message)
        user = @db.find_or_create_user_by_chat_id(message.from.id)
        @db.update_user(state: 'create_gift', chat_id: message.from.id)
        @bot.api.send_message(chat_id: message.from.id, text: "Введите название подарка:")
    end
      
    def create_gift(message)
        user = @db.find_or_create_user_by_chat_id(message.from.id)
        gift_id = @db.create_gift(gift: message.text, price:nil, user_id:user[:id])
        @db.update_user(state: 'set_gift_price', current_gift_id: gift_id, chat_id: message.from.id)
        p @db.find_or_create_user_by_chat_id(message.from.id)
        @bot.api.send_message(chat_id: message.from.id, text: "Укажите цену подарка:")
    end
    
    def set_gift_price(message)
        user = @db.find_or_create_user_by_chat_id(message.from.id)
        @db.update_gift_price(price: message.text, id: user[:current_gift_id])
        @db.update_user(state: 'initial_state', chat_id: message.from.id)
        @bot.api.send_message(chat_id: message.from.id, text: "Подарок добавлен!")
    end    
end