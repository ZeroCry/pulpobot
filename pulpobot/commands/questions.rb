module PulpoBot
  module Commands
    class Questions < SlackRubyBot::Commands::Base
      
      bot = Cleverbot.new('1d4seUHqQlPX1iTE', 'pU2ZVB0g0cRkGiFIbxVcSdczvcW87V3K')
      
      @mp_account = ""
  
      match(/^(?<bot>\w*)\s(?<expression>.*)$/) do |client, data, match| 
        
        puts "CLIENT: #{client}   |   DATA: #{data}   |   MATCH: #{match[:expression]} \n " 
        
        expression = match[:expression] 
        
        mp_match_money_request = /cobrale (?<amount>.*) a (?<person>.*)$/.match(expression)
        mp_account_request = /^mi email de mercadopago es (?<account>.*)$/.match(expression)
        
        
        p "MATCH MP: #{mp_match_money_request.inspect} \n"
        
        if mp_account_request != nil
          
          @mp_account = mp_account_request[:account]
        
        elsif mp_match_money_request != nil 
          
          money_request       = MercadoPago::MoneyRequest.new
          money_request.currency_id   = "ARS"
          money_request.amount        = mp_match_money_request[:amount].scan(/\d/).join('').to_f
          money_request.payer_email   = @mp_account
          money_request.description   = "PulpoBot Request"
          money_request.concept_type  = "off_platform"
          begin
            money_request.save do |response|
              
              puts " \n ============== \n"
              puts response
              puts " \n ============== \n"
              
              if response.code.to_s == "200" 
                client.say(channel: data.channel, text: "#{mp_match_money_request[:person]} pagale los #{mp_match_money_request[:amount]} aqui: #{money_request.init_point}")
              else 
                error_msg = JSON.parse(response.body)["message"]
                client.say(channel: data.channel, text: "#{response.message} : #{error_msg}")
              end
            end
          rescue Exception => e
            puts " \n ============== \n"
            puts "ERROR: #{e}"
            puts " \n ============== \n"
            client.say(channel: data.channel, text: e.message)
          end
            
        else
          client.say(channel: data.channel, text: bot.say(match[:expression]))
        end
        
        
        
      end
      
    end
  end
end