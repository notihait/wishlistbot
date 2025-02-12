# frozen_string_literal: true

class WishlistsController < Controller
  def new_wishlist(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    user.update(state: 'create_wishlist')
    @bot.api.send_message(chat_id: message.from.id, text: 'Введите название вишлиста:')
  end

  def create_wishlist(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    wishlist = user.wishlists.create(name: message.text)
    user.update(state: 'set_wishlist_date', current_wishlist: wishlist)
    @bot.api.send_message(chat_id: message.from.id, text: 'Введите дату вашего события:')
  end

  def set_wishlist_date(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    user.current_wishlist.update(event_date: message.text)
    user.update(state: 'new_gift')
    @bot.api.send_message(chat_id: message.from.id, text: 'Вишлист создан! Теперь давайте добавим подарок:')
  end

  def show_my_wishlists(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    user.update(state: 'show_my_wishlists')
    @bot.api.send_message(chat_id: message.from.id, text: "Ваши вишлисты :#{user.wishlists}")
  end

  def show_user_wishlists(message)
    #  user = User.find_or_create_by(chat_id: message.from.id)
    #  user.update(state: 'show_user_wishlists')
  end
end
