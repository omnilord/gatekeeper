module Gatekeeper
  module Greet
    module_function

    def greet(server, user)
      setting = Database::Greeting.for(server.resolve_id)

      unless setting.nil? || !setting.active
        cid = setting.value['channel_id'] || user.pm
        channel = GatekeeperBot::BOT.channel(cid)

        unless channel.nil?
          msg = setting.value['message']
          h = { user: user.mention, server: server.name }
          h.default = ''
          channel.send(format(msg, h))
        end
      end
    end

    def toggle(server, active)
      Database::Greeting.toggle(server.resolve_id, active)
    end

    def save(server, channel, msg, active = true)
      fields = {
        entity_id: server.resolve_id,
        active: !!active,
        value: Sequel.pg_jsonb({
          channel_id: channel&.resolve_id,
          message: msg
        })
      }
      Database::Greeting.upsert(**fields).first
    end

    def delete(server)
      Database::Greeting.remove(server.resolve_id)
    end
  end
end
