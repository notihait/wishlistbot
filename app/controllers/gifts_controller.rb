# frozen_string_literal: true

class GiftsController < Controller
  def new_gift(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    user.update(state: 'create_gift')
    @bot.api.send_message(chat_id: message.from.id, text: 'Введіть назву подарунку:')
  end

  def create_gift(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    gift = user.current_wishlist.gifts.create(name: message.text)
    user.update(state: 'set_gift_price', current_gift: gift)
    @bot.api.send_message(chat_id: message.from.id, text: 'Введіть ціну подарунку:')
  end

  def set_gift_price(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    user.current_gift.update(price: message.text.to_i)
    user.update(state: 'create_gift')
    @bot.api.send_message(chat_id: message.from.id, text: 'Подарунок додано! Введіть назву наступного подарунку або натисніть клавішу "Вийти в меню"')
  end
end
