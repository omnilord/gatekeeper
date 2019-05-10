require 'json'

module GatekeeperBot
  module_function

  DEFAULT_BUCKET_CONFIG = { limit: 1, time_span: 3, delay: nil }.freeze

  ADMINS = Credentials[:discord][:bot_admins].map(&:to_i) || []

  def admin?(user)
    ADMINS.include? user.resolve_id
  end
end
