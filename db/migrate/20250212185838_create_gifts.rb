# frozen_string_literal: true

class CreateGifts < ActiveRecord::Migration[8.0]
  def change
    create_table :gifts do |t|
      t.string :name, null: false
      t.string :link
      t.integer :price
      t.references :wishlist
    end
  end
end
