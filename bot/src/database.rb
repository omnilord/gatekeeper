require 'sequel'
Sequel.extension(:pg_json_ops)
Sequel::Model.plugin :timestamps

module Database
  at_exit do
    GatekeeperBot::LOG.info('Closing Database')
    DB&.disconnect
  end

  url = ENV.fetch('DATABASE_URL', "postgres:///gatekeeperbot_#{ENV.fetch('RAILS_ENV', 'development')}")
  DB = Sequel.connect(url)
  DB.extension(:pg_json)

  # base classes/datasets for existing tables w/o qualifications.  Move
  #   into databases/<%tablename%>.rb if extending functionality.
end

Dir[File.dirname(File.absolute_path(__FILE__)) + '/database/*.rb'].each do |file|
  GatekeeperBot::LOG.debug("Loading #{file}")
  require file
end
