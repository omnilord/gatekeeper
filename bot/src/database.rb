require 'sequel'
Sequel.extension(:pg_json_ops)

module Database
  at_exit do
    GatekeeperBot::LOG.info('Closing Database')
    DB&.disconnect
  end

  url = ENV.fetch('DATABASE_URL', "postgres:///gatekeeperbot_#{ENV.fetch('RAILS_ENV', 'development')}")
  puts "DB URL: #{url}"
  DB = Sequel.connect(url)
  DB.extension(:pg_json)

  # base classes for existing tables w/o qualifications
  #   Move into modules/databases/<%tablename%>.rb if
  #   extending functionality
  class Setting < Sequel::Model; end
end

Dir[File.dirname(File.absolute_path(__FILE__)) + '/modules/database/*.rb'].each do |file|
  GatekeeperBot::LOG.debug("Loading #{file}")
  require file
end
