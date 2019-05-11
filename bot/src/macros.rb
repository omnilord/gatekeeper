require 'json'
require 'ostruct'

module GatekeeperBot
  module_function

  AppPermissionError = Class.new(StandardError)

  DEFAULT_BUCKET_CONFIG = { limit: 1, time_span: 3, delay: nil }.freeze

  ADMINS = Credentials[:discord][:bot_admins].map(&:to_i) || []

  def admin?(user)
    ADMINS.include? user.resolve_id
  end

  def allowed?(event, permissions)
    admin?(event.user) \
      || (permissions.respond_to?(:empty?) && permissions.empty?) \
      || (permissions.respond_to?(:any?) \
          && permissions.any? { |can| event.user.permission?(can, event.channel) })
  end

  def cmd_log(type, flag, uuid, event, user, message)
    s = event.server.nil? ? 'pm' : "#{event.server.name}(#{event.server.id})"
    c = event.channel.nil? ? 'pm' : "#{event.channel.name}(#{event.channel.id})"
    u = "#{user.username}(#{user.user_id})"
    LOG.send(type, "$$#{flag}:#{uuid}:#{s}/##{c}:@#{u}:#{message}")
  end

  def delete_command(event)
    permissioned_eval(event, :manage_messages) do
      event.message.delete
      yield if block_given?
    end
  end

  def permissioned_eval(event, *permissions, **kwargs)
    return nil unless block_given?
    return nil if event.server.nil?

    bot_profile = GatekeeperBot::BOT.profile.on(event.server)
    channel = kwargs.fetch(:channel, event.channel)
    permissions.each do |permission|
      raise AppPermissionError unless bot_profile.permission?(permission, channel)
    end

    yield
  rescue AppPermissionError, Discordrb::Errors::NoPermission => er
    bot_user = OpenStruct.new(username: 'GatekeeperBot::BOT', user_id: 'self')
    cmd_log(:error, '!permissioned_eval', er.class.name, event, bot_user, er.inspect)
    nil
  end
end
