# frozen_string_literal: true

class WishlistsController < Controller
  def new_wishlist(message)
    user = @db.find_or_create_user_by_chat_id(message.from.id)
    @db.update_user(state: 'create_wishlist', chat_id: message.from.id)
    @bot.api.send_message(chat_id: message.from.id, text: "Введите название вишлиста:")
  end
  
  def create_wishlist(message)
    user = @db.find_or_create_user_by_chat_id(message.from.id)
    wishlist_id = @db.create_list(wishlist_name: message.text, event_date:nil, user_id:user[:id])
    @db.update_user(state: 'set_wishlist_date', current_wishlist_id: wishlist_id, chat_id: message.from.id)
    p @db.find_or_create_user_by_chat_id(message.from.id)
    @bot.api.send_message(chat_id: message.from.id, text: "Введите дату вашего события:")
  end

  def set_wishlist_date(message)
    user = @db.find_or_create_user_by_chat_id(message.from.id)
    @db.update_list_date(event_date: message.text, id: user[:current_wishlist_id])
    @db.update_user(state: 'new_gift', chat_id: message.from.id)
    @bot.api.send_message(chat_id: message.from.id, text: "Вишлист создан! Теперь давайте добавим подарок")
  end

  def show_my_wishlists(message) 
  user = @db.find_or_create_user_by_chat_id(message.from.id)
  @db.update_user(state: 'show_my_wishlists', chat_id: message.from.id)
  wishlists_list = @db.get_lists(user_id:user[:id])
  @bot.api.send_message(chat_id: message.from.id, text: "Ваши вишлисты :#{wishlists_list}")

  end

  def show_user_wishlists(message); 
  #user = @db.find_or_create_user_by_chat_id(message.from.id)
  #@db.update_user(state: 'show_user_wishlists', chat_id: message.from.id)
  #@bot.api.send_message(chat_id: message.from.id, text: "Введите айди пользователя:")
  #wishlists_list = @db.get_lists(user_id: message.text)
  #@bot.api.send_message(chat_id: message.from.id, text: "Вишлисты пользователя:#{wishlists_list}")
  end
end