# frozen_string_literal: true

module Core
  class Dispatcher
    def initialize(db, bot)
      @db = db
      @bot = bot
    end

    def wishlists_controller
      @wishlists_controller ||= WishlistsController.new(@db, @bot)
    end

    def home_controller
      @home_controller ||= HomeController.new(@db, @bot)
    end

    def process_message(message)
      return unless message.is_a?(Telegram::Bot::Types::Message)

      case message.text
      when '/start'
        home_controller.start(message)
      when 'Создать вишлист'
        wishlists_controller.new_wishlist(message)
      when 'Просмотреть свои вишлисты'
        wishlists_controller.show_my_wishlists(message)
      when 'Просмотреть вишлист друга'
        wishlists_controller.show_user_wishlists(message)
      else
        user = @db.find_or_create_user_by_chat_id(message.from.id)
        case user[:state]
        when 'creating_wishlist'
          wishlists_controller.new_wishlist(message)
                        puts "User state: #{user[:state]}"
          @db.update_user(chat_id: message.from.id, state: 'waiting_for_wishlist_name')
        when 'waiting_for_wishlist_name'
          wishlists_controller.waiting_for_list_name(message)
          @db.update_user(chat_id: message.from.id, state: 'got the name')
                        puts "User state: #{user[:state]}"
        else
          @bot.api.send_message(chat_id: message.from.id, text: 'Я хз')
        end
      end
    end
  end
end

# добавление подарка, стейт для добавления, 
# в долгий ящик изменение