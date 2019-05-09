module GatekeeperBot
  LOG = Discordrb::Logger.new(true, [STDOUT, File.open('log/bot.log', 'a')])
  LOG.mode = :debug # uncomment for verbose diagnostic information
end
