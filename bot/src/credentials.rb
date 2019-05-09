require 'active_support/core_ext/hash/keys'
require 'active_support/encrypted_configuration'

module GatekeeperBot
  module Credentials
    @root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    Data = ActiveSupport::EncryptedConfiguration.new(
      config_path: File.join(@root, 'config', 'credentials.yml.enc'),
      key_path: File.join(@root, 'config', 'master.key'),
      env_key: 'RAILS_MASTER_KEY',
      raise_if_missing_key: true
    )

    def self.[](key)
      Data[key]
    end
  end
end
