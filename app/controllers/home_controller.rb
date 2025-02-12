# frozen_string_literal: true

class HomeController < Controller
  def start(message)
    user_full_name = "#{message.from.first_name} #{message.from.last_name}"
    reply_markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [
                                                                   [{ text: 'Створити вішліст' }],
                                                                   [{ text: 'Продивитись свої вішлісти' }],
#                                                                   [{ text: 'Просмотреть вишлист друга' }],
                                                                   [{ text: 'Вийти в меню'}]
                                                                 ])
    @bot.api.send_message(chat_id: message.from.id,
                          text: "Привіт, #{user_full_name} 👋",
                          reply_markup: reply_markup)
  end

  def reset_state(message)
    user = User.find_or_create_by(chat_id: message.from.id)
    user.update(state: "initial_state", current_wishlist: nil, current_gift: nil)
    @bot.api.send_message(chat_id: message.from.id, text: "Ви вийшли в меню")
  end

end

