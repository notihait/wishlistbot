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
        p 5
      end
    end
  end
end
