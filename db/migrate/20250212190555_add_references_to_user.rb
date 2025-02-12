class AddReferencesToUser < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :current_wishlist, foreign_key: { to_table: :wishlists}
    add_reference :users, :current_gift, foreign_key: { to_table: :gifts}
    add_foreign_key :wishlists, :users, column: :user_id, null: false
    add_foreign_key :gifts, :wishlists, column: :wishlist_id, null: false
    add_foreign_key :users, :wishlists, column: :current_wishlist_id, null: true
    add_foreign_key :users, :gifts, column: :current_gift_id, null: true
  end
end
