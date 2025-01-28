# frozen_string_literal: true

module Core
  def self.require_source
    require 'dotenv/load'
    require 'telegram/bot'
    require 'pry'

    Dir['./app/*/*.rb'].each { |file| require_relative file }
    Dir['./core/*.rb'].each { |file| require_relative file }
  end
end
