module GatekeeperBot::DiscordEvents
  module Join
    extend Discordrb::EventContainer
    member_join do |event|
      Gatekeeper::Greet.greet(event.server, event.user)
    rescue StandardError => er
      GatekeeperBot::LOG.error(er.backtrace)
    end
  end
end
