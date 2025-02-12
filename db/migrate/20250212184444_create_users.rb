# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.integer :chat_id, index: { unique: true }, null: false
      t.string :state
      #  current_wishlist_id INTEGER,
      #  current_gift_id INTEGER,
      #  FOREIGN KEY (current_wishlist_id) REFERENCES lists(id),
      #  FOREIGN KEY (current_gift_id) REFERENCES items(id)
    end
  end
end
