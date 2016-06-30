module PulpoBot
  module Commands
    class Questions < SlackRubyBot::Commands::Base
      bot = Cleverbot.new(ENV['API_USER'], ENV['API_KEY'], 'sessionname')
  
      match(/^(?<bot>\w*)\s(?<expression>.*)$/) do |client, data, match| 
        client.say(channel: data.channel, text: bot.say(match[:expression]))
      end
    end
  end
end