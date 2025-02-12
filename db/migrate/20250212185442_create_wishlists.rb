# frozen_string_literal: true

class CreateWishlists < ActiveRecord::Migration[8.0]
  def change
    create_table :wishlists do |t|
      t.string :name
      t.references :user
      t.date :event_date
    end
  end
end
