module GatekeeperBot::DiscordCommands
  module Greeter
    extend Discordrb::Commands::CommandContainer

    GREET = :greet

    USAGE = {
      GREET => 'greet [private|#channel|here|on|off|delete] [<msg>]'
    }.freeze

    HELP = {}
    HELP[GREET] = <<~TXT
      Manage the greeting message for this server.
      the first word of the message should be the word
      `private`, the word `here`, or a mentioned channel
      (#channel-name).

      Also supported are `on`, `off`, and `delete` which do
      exactly what they imply.

      Greeting message supports interpolating the server
      name (use %{server}) and the user name (use %{user}).

      ex.:
      +greet here Hello %{user}!  Welcome to %{server}!
      will yield: "Hello <@1234567890> Welcome to This Amazing Server!"
    TXT
    HELP.freeze

    BUCKET = GatekeeperBot::BOT.bucket(:greeter, GatekeeperBot::DEFAULT_BUCKET_CONFIG)

    command(GREET, usage: USAGE[GREET], description: HELP[GREET], bucket: :greeter) do |event, *args|
      next if event.server.nil? || !GatekeeperBot.allowed?(event, [:manage_server])

      greeting =
        if args.length.zero?
          Database::Greeting[entity_id: event.server.resolve_id]
        else
          case args[0].downcase
          when 'delete'
            Gatekeeper::Greet.delete(event.server)
          when 'on'
            Gatekeeper::Greet.toggle(event.server, true)
          when 'off'
            Gatekeeper::Greet.toggle(event.server, false)
          when 'private'
            Gatekeeper::Greet.save(event.server, nil, args[1..-1].join(' '))
          when 'here'
            Gatekeeper::Greet.save(event.server, event.channel, args[1..-1].join(' '))
          when /\A<#(\d+)>\z/
            ch = GatekeeperBot::BOT.channel($1.to_i) || event.channel
            Gatekeeper::Greet.save(event.server, ch, args[1..-1].join(' '))
          else
            raise 'First argument should be `on`, `off`, `delete`, `here`, `private`, or a channel mention `#channelname`.'
          end
        end

      if greeting.nil?
        'No greeting is set.'
      elsif greeting[:deleted]
        'Greeting deleted.'
      elsif greeting[:active]
        ch = GatekeeperBot::BOT.channel(greeting[:value]['channel_id'].to_i)
        msg = greeting[:value]['message']
        "Greeting message will be sent to #{ch.nil? ? '`DM`' : ch.mention}:\n```\n#{msg}\n```"
      else
        'Greeting message is `OFF`.'
      end
    rescue => er
      GatekeeperBot::LOG.error(([er.message, ''] + er.backtrace).join("\n"))
      er.message
    end
  end
end
