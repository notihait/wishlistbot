# frozen_string_literal: true

class WishlistsController < Controller
  def new_wishlist(message)
    user = @db.find_or_create_user_by_chat_id(message.from.id)
    user.update(state: 'creating_wishlist')
    @bot.api.send_message(chat_id: message.from.id, text: "Введите название вишлиста:")
    user.update(state: 'waiting_for_wishlist_name')
  end

  def waiting_for_wishlist_name(message)
    user = @db.find_user_by_chat_id(message.from.id)
    if user[:state] == 'waiting_for_wishlist_name'
      wishlist_name = message.text
      @db.create_list(wishlist_name: wishlist_name, user_id: user[:id], event_date: nil)
      user.update(state: 'adding_gifts')
      @bot.api.send_message(chat_id: message.from.id, text: "Вишлист '#{wishlist_name}' создан. Теперь вы можете добавлять подарки.")
    else
      @bot.api.send_message(chat_id: message.from.id, text: "Кажется, что-то пошло не так. Пожалуйста, начните создание вишлиста заново.")
    end
  end

  def show_my_wishlists(message); end

  def show_user_wishlists(message); end
end