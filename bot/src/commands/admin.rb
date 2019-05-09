module GatekeeperBot::DiscordCommands
  # Administrative commands exclussive ot owner and the most trusted users

  module Admin
    extend Discordrb::Commands::CommandContainer

    NO_HELP = true

    # shutdown the bot process
    command(:shutdown, help_available: false) do |event, *args|
      next unless GatekeeperBot::admin?(event.user)
      shutdown_bot('Shutdown Command from owner.')
    end
    # report status on the bot to the administrator
    command(:servers, help_available: false) do |event, *args|
      next unless GatekeeperBot::admin?(event.user)
      event.bot.servers.values.map { |s| "`#{s.name}`" }.join(', ')
    end
  end
end
