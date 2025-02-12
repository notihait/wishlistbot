# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :wishlists
  belongs_to :current_wishlist, class_name: 'Wishlist', foreign_key: 'current_wishlist_id'
end
