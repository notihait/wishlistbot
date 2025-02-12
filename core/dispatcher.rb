# frozen_string_literal: true

module Core
  class Dispatcher
    def initialize(bot)
      @bot = bot
    end

    def gifts_controller
      @gifts_controller ||= GiftsController.new(@bot)
    end

    def wishlists_controller
      @wishlists_controller ||= WishlistsController.new(@bot)
    end

    def home_controller
      @home_controller ||= HomeController.new(@bot)
    end

    def process_message(message)
      return unless message.is_a?(Telegram::Bot::Types::Message)
      
      unless message.text.match(/^\/start/).nil?
        if message.text.gsub("/start", "").blank?
          home_controller.start(message)
        else
          wishlists_controller.show_wishlist(message)
        end
        return
      end

      case message.text
        
      when 'Создать вишлист'
        wishlists_controller.new_wishlist(message)
      when 'Просмотреть свои вишлисты'
        wishlists_controller.show_my_wishlists(message)
#      when 'Просмотреть вишлист друга'
#        wishlists_controller.show_user_wishlist(message)
      when 'Выйти в меню'
        home_controller.reset_state(message)
      else
        user = User.find_or_create_by(chat_id: message.from.id)
        case user.state
        when 'create_wishlist'
          wishlists_controller.create_wishlist(message)
        when 'set_wishlist_date'
          wishlists_controller.set_wishlist_date(message)
        when 'new_gift'
          gifts_controller.new_gift(message)
        when 'create_gift'
          gifts_controller.create_gift(message)
        when 'set_gift_price'
          gifts_controller.set_gift_price(message)
        else
          @bot.api.send_message(chat_id: message.from.id, text: 'Я хз')
        end
      end
    end
  end
end
