# frozen_string_literal: true

class WishlistsController < Controller
  def new_wishlist(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    user.update(state: 'create_wishlist')
    @bot.api.send_message(chat_id: message.from.id, text: 'Введіть назву вішлісту:')
  end

  def create_wishlist(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    wishlist = user.wishlists.create(name: message.text)
    user.update(state: 'set_wishlist_date', current_wishlist: wishlist)
    @bot.api.send_message(chat_id: message.from.id, text: 'Введіть дату вашої події:')
  end

  def set_wishlist_date(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    user.current_wishlist.update(event_date: message.text)
    user.update(state: 'create_gift')
    @bot.api.send_message(chat_id: message.from.id, text: 'Вішліст створено! Тепер давайте добавимо подарунок. Введіть для нього назву:')
  end

  def show_my_wishlists(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    user.update(state: 'show_my_wishlists')
    wishlists = user.wishlists.map do |wishlist|
      render_wishlist(wishlist)
    end.join("\n")
    @bot.api.send_message(chat_id: message.from.id, text: "Ваші вішлісти:\n#{wishlists}", parse_mode: "HTML")
  end

  def show_wishlist(message)
    wishlist = Wishlist.find(message.text.gsub("/start ", "").to_i)
    wishlist = render_wishlist(wishlist)
    @bot.api.send_message(chat_id: message.from.id, text: wishlist, parse_mode: "HTML")
  end

  def render_wishlist(wishlist)

    header = "<a href=\"https://t.me/IWIshList_bot?start=#{wishlist.id}\" >лінк</a> | название: #{wishlist.name} | дата: #{wishlist.event_date}\n"
    gifts = wishlist.gifts.map do |gift|
      "  название: #{gift.name} | цена: #{gift.price} грн"
    end.join("\n")
    [header, gifts].join("")

  end
end
