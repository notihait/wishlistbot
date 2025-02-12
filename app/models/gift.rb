# frozen_string_literal: true

class Gift < ActiveRecord::Base
  belongs_to :wishlist
end
