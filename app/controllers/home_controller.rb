# frozen_string_literal: true

class HomeController < Controller
  def start(message)
    message.from.id
    user_full_name = "#{message.from.first_name} #{message.from.last_name}"
    reply_markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [
                                                                   [{ text: 'Создать вишлист' }],
                                                                   [{ text: 'Просмотреть свои вишлисты' }],
                                                                   [{ text: 'Просмотреть вишлист друга' }]
                                                                 ])
    @bot.api.send_message(chat_id: message.from.id,
                          text: "Привет, #{user_full_name} 👋",
                          reply_markup: reply_markup)
  end
end
