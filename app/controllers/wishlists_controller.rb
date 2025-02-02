# frozen_string_literal: true

class WishlistsController < Controller
  def new_wishlist(message)
    @bot.api.send_message(chat_id: message.from.id,
                          text: "Введите название подарка:")

  end

  def show_my_wishlists(message); end

  def show_user_wishlists(message); end
end
