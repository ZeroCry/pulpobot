module PulpoBot
  module Commands
    class Questions < SlackRubyBot::Commands::Base
      
      bot = Cleverbot.new('1d4seUHqQlPX1iTE', 'pU2ZVB0g0cRkGiFIbxVcSdczvcW87V3K')
  
      match(/^(?<bot>\w*)\s(?<expression>.*)$/) do |client, data, match| 
        
        puts "CLIENT: #{client}   |   DATA: #{data}   |   MATCH: #{match[:expression]} \n " 
        
        expression = match[:expression] 
        
        mp_match = /cobrale (?<amount>.*) a (?<person>.*)$/.match(expression)
        
        p "MATCH MP: #{mp_match.inspect} \n"
        
        if mp_match != nil 
          
          money_request       = MercadoPago::MoneyRequest.new
          money_request.currency_id = "ARS"
          money_request.amount = mp_match[:amount].scan(/\d/).join('').to_f
          money_request.payer_email = "niohnex@gmail.com"
          money_request.description = "PulpoBot Request"
          money_request.concept_type = "off_platform"
          
          money_request.save
          
          client.say(channel: data.channel, text: "#{mp_match[:person]} pagale los #{mp_match[:amount]} aqui: #{money_request.init_point}")
          
        else
          client.say(channel: data.channel, text: bot.say(match[:expression]))
        end
        
        
        
      end
      
    end
  end
end