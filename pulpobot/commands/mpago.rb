module PulpoBot
  module Commands
    
    class MPago < SlackRubyBot::Commands::Base
      match(/^@(?<bot>\w*):\scobrale\s(?<amount>.*)\sa\s(?<person>.*)$/) do |client, data, match|
        puts "CLIENT: #{client}   |   DATA: #{data}   |   MATCH: #{match[:expression]} " 
        client.say(channel: data.channel, text: match.inspect.to_s)
      end
    end
    
  end
end