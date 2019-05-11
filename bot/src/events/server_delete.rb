module GatekeeperBot::DiscordEvents
  module ServerDelete
    extend Discordrb::EventContainer

    server_delete do |event|
      Database::Settings.where(entity_id: event.server.resolve_id).delete
    rescue StandardError => er
      GatekeeperBot::LOG.error(([er.message, ''] + er.backtrace).join("\n"))
    end
  end
end
