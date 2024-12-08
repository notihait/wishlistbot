require 'telegram/bot'
require_relative 'database'

class TelegramBot
  attr_reader :bot

  def initialize(token, db)
    @token = token
    @bot = Telegram::Bot::Client.new(@token)
    @db = db
  end

  def run
    @bot.run do |bot|
      bot.listen do |message|
        case message
        when Telegram::Bot::Types::Message
          user_id = message.from.id
          case message.text
          when "/start"
            user_full_name = "#{message.from.first_name} #{message.from.last_name}"
            reply_markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [
                [{text: "Создать вишлист"}],
                [{text: "Просмотреть свои вишлисты"}],
                [{text: "Просмотреть вишлист друга"}]
            ])
            bot.api.send_message(chat_id: message.from.id, text: "Привет, #{user_full_name} 👋", reply_markup: reply_markup)

          when "Создать вишлист"
            gift_name = get_user_input(bot, message.chat.id, "Введите название подарка:")
            gift_link = get_user_input(bot, message.chat.id, "Введите ссылку на подарок (необязательно):")
            gift_price = get_user_input(bot, message.chat.id, "Введите цену подарка:")
            gift_date = get_user_input(bot, message.chat.id, "Введите дату события (ГГГГ-ММ-ДД):")

            begin
              @db.add_gift(user_id, gift_name, gift_link, gift_price, gift_date)
              bot.api.send_message(chat_id: message.chat.id, text: "Подарок добавлен! Его код: #{wishlist_id}")
            rescue ArgumentError, SQLite3::Exception => e
              bot.api.send_message(chat_id: message.chat.id, text: "Ошибка: #{e.message}")
            end

          when "Просмотреть свои вишлисты"
            wishlists = @db.get_user_wishlists(user_id)
            if wishlists.empty?
              bot.api.send_message(chat_id: message.chat.id, text: "У вас пока нет вишлистов.")
            else
              wishlist_text = "Ваши вишлисты:\n"
              wishlists.each do |row|
                wishlist_text += "ID: #{row[0]}, Подарок: #{row[2]}, Ссылка: #{row[3]}, Цена: #{row[4]}, Дата: #{row[5]}\n"
              end
              bot.api.send_message(chat_id: message.chat.id, text: wishlist_text)
            end

          when "Просмотреть вишлист друга"
            bot.api.send_message(chat_id: message.from.id, text: "Напиши код вишлиста друга")
            #@get_friends_wishlist(id)
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Я хз")
          end
        end
      end
    end
  end

  def get_user_input(bot, chat_id, question)
    bot.api.send_message(chat_id: chat_id, text: question)
    Timeout::timeout(999999) do 
      message = bot.listen { |m| m.chat.id == chat_id && m.text }
      message&.text
    end
  rescue Timeout::Error
    puts "Timeout error"
    return nil
  rescue StandardError => e
    puts "Error in get_user_input: #{e.message}"
    return nil
  end
end
