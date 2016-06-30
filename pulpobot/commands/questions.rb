module PulpoBot
  module Commands
    class Questions < SlackRubyBot::Commands::Base
      bot = CleverBot.new
  
      match(/^(?<bot>\w*)\s(?<expression>.*)$/) do |client, data, match| 
        client.say(channel: data.channel, text: bot.think(match[:expression))
      end
    end
  end
end