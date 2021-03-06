module GatekeeperBot::DiscordEvents
  module Join
    extend Discordrb::EventContainer

    member_join do |event|
      Gatekeeper::Greet.greet(event.server, event.user)
    rescue StandardError => er
      GatekeeperBot::LOG.error(([er.message, ''] + er.backtrace).join("\n"))
    end
  end
end
