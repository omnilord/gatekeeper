require 'json'

module GatekeeperBot
  module_function

  adminlistfile = File.realpath(__dir__ + '/../') + '/admins.json'
  ADMINS = Credentials[:discord][:bot_admins].map(&:to_i) || []

  def admin?(user)
    ADMINS.include? user.resolve_id
  end
end
