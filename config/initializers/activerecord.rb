# frozen_string_literal: true

config = File.read('db/config.yml')
config = YAML.safe_load(config)[Core::APPLICATION_ENV]
ActiveRecord::Base.establish_connection(config)
ActiveRecord::Base.logger = Logger.new($stdout) if Core::APPLICATION_ENV == 'develompent'
