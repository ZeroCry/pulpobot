module PulpoBot
  module Commands
    
    class MPago < SlackRubyBot::Commands::Base
      match(/^(?<bot>\w*) cobrale (?<amount>.*) a (?<person>.*)$/) do |client, data, match|
        
        puts "CLIENT: #{client}   |   DATA: #{data}   |   MATCH: #{match.inspect} " 
        
        client.say(channel: data.channel, text: match.inspect.to_s)
        
      end
    end
    
  end
end