# Gems
require 'discordrb'
require_relative 'log'
require_relative 'credentials'
require_relative 'database'

# Post-run cleanup activities
def shutdown_bot(msg = 'unknown shutdown')
  GatekeeperBot::LOG.info(msg)
  GatekeeperBot::BOT.stop(true)
  pidfile = File.realpath(__dir__ + '/../') + '/bot.pid'
  File.delete(pidfile) if File.exist?(pidfile)
  exit
end
trap('INT') { shutdown_bot('Interrupt signal - exiting.') }

module GatekeeperBot
  Dir['src/modules/*.rb'].each { |mod| load mod }

  NAME = 'Gatekeeper'
  PREFIX = '+'
  BOT = Discordrb::Commands::CommandBot.new(
    client_id: Credentials[:discord][:id],
    token: Credentials[:discord][:bot_secret],
    prefix: PREFIX
  )

  def self.load_modules(klass, path)
    new_module = Module.new
    const_set(klass.to_sym, new_module)
    Dir["src/modules/#{path}/*.rb"].each { |file| load file }
    new_module.constants.each do |mod|
      BOT.include! new_module.const_get(mod)
    end
  end

  load_modules(:DiscordEvents, 'events')
  load_modules(:DiscordCommands, 'commands')

  # Run the bot
  BOT.run
end
