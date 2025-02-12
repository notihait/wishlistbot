# frozen_string_literal: true

class Wishlist < ActiveRecord::Base
  has_many :gifts
  belongs_to :user
end
