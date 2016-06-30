module PulpoBot
  module Commands
    class Questions < SlackRubyBot::Commands::Base
      
      bot = Cleverbot.new('1d4seUHqQlPX1iTE', 'pU2ZVB0g0cRkGiFIbxVcSdczvcW87V3K')
  
      match(/^(?<bot>\w*)\s(?<expression>.*)$/) do |client, data, match| 
        
        puts "CLIENT: #{client}   |   DATA: #{data}   |   MATCH: #{match[:expression]} \n " 
        
        expression = match[:expression] 
        
        mp_match = /cobrale (?<amount>.*) a (?<person>.*)$/.match(expression)
        
        p "MATCH MP: #{mp_match.inspect} \n"
        
        if mp_match
          client.say(channel: data.channel, text: bot.say("#{mp_match[:person]} pagale los #{mp_match[:amount]}"))
        else
          client.say(channel: data.channel, text: bot.say(match[:expression]))
        end
        
        
        
      end
      
    end
  end
end