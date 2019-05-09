module Gatekeeper
  module_function

  def greet(server, user)
    setting = Database::Greeting.first(entity_id: server.id)
    unless setting.nil?
      cid = setting.value['channel_id'] || user.pm
      channel = GatekeeperBot::BOT.channel(cid)

      unless channel.nil?
        msg = setting.value['message']
        greeting = format(msg, user: user.mention, server: server.name)

        channel.send(greeting)
      end
    end
  end
end
