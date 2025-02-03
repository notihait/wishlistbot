# frozen_string_literal: true

class WishlistsController < Controller
  def new_wishlist(message)
    user = @db.find_or_create_user_by_chat_id(message.from.id)
    user.update(state: 'creating_wishlist')
    @bot.api.send_message(chat_id: message.from.id,
                          text: "Введите название подарка:")

  end

  def show_my_wishlists(message); end

  def show_user_wishlists(message); end
end
