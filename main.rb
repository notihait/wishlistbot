#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'core'
Core.require_source

Core::TelegramBot.new(ENV['TELEGRAM_TOKEN'], Core::Database.new).run
