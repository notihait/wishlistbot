#!/usr/bin/env ruby

require 'dotenv/load'
require_relative "telegram_bot"

TelegramBot.new(ENV['TELEGRAM_TOKEN'], Database.new).run
