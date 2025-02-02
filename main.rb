#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'core'
Core.require_source
if ARGV.include? "console"
  binding.pry
else 
  Core::TelegramBot.new(ENV['TELEGRAM_TOKEN'], Core::Database.new).run
end