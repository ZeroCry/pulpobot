module PulpoBot
  module Commands
    class Questions < SlackRubyBot::Commands::Base
      bot = Cleverbot.new('1d4seUHqQlPX1iTE', 'pU2ZVB0g0cRkGiFIbxVcSdczvcW87V3K', 'sessions')
  
      match(/^(?<bot>\w*)\s(?<expression>.*)$/) do |client, data, match| 
        puts "CLIENT: #{client}   |   DATA: #{data}   |   MATCH: #{match} "
        client.say(channel: data.channel, text: bot.say(match[:expression]))
      end
    end
  end
end