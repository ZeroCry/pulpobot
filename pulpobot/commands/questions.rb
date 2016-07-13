require 'net/http'
require 'open-uri'
require 'json'

module PulpoBot
  module Commands
    class Questions < SlackRubyBot::Commands::Base
      
      bot = Cleverbot.new('1d4seUHqQlPX1iTE', 'pU2ZVB0g0cRkGiFIbxVcSdczvcW87V3K')
      
      @mp_accounts = Hash.new
      @guardia = nil
      @numbers = Hash.new
  
      match(/^(?<bot>\w*)\s(?<expression>.*)$/) do |client, data, match| 
         
        expression = match[:expression] 
        
        mp_match_money_request = /cobrale (?<amount>.*) a (?<person>.*)$/.match(expression)
        mp_account_request = /el email de mercadopago de (?<person>.*) es (?<account>.*)$/.match(expression)
        wanna_joke = /(chiste)/.match(expression)
        set_guard_person = /(?<person>.*) esta de guardia$/.match(expression)
        get_guard_person = /(quien esta de guardia)/.match(expression)
        send_a_sms = /enviale un sms a (?<person>.*) y dile (?<message>.*)/.match(expression)
        save_a_number = /el numero de (?<person>.*) es (?<number>.*)/.match(expression)
        panther = /(la pantera)/.match(expression) 
        sentiment_analysis = /(haz un analisis de sentimiento de) (?<prhase>.*) /.match(expression) 
        
        pokemon = /(pokedex) (?<pokemon>.*)/.match(expression) 
        
        if mp_account_request != nil
          
          mail_match = /.*:(?<email>.*)\|/.match(mp_account_request[:account]) 
          @mp_accounts[mp_account_request[:person]] = mail_match[:email] 
          client.say(channel: data.channel, text: ["Guardado", "Ok!", "Dale"].sample)
        
        elsif mp_match_money_request != nil 
          
          money_request       = MercadoPago::MoneyRequest.new
          money_request.currency_id   = "ARS"
          money_request.amount        = mp_match_money_request[:amount].scan(/\d/).join('').to_f 
          money_request.payer_email   = @mp_accounts[mp_match_money_request[:person]]
          money_request.description   = "PulpoBot Request"
          money_request.concept_type  = "off_platform"
          begin
            money_request.save do |response| 
              if response.code.to_s == "200" || response.code.to_s == "201" 
                client.say(channel: data.channel, text: "#{mp_match_money_request[:person]} pagale los #{mp_match_money_request[:amount]} aqui: #{money_request.init_point}")
              else 
                if @mp_account.nil? 
                  client.say(channel: data.channel, text: "Ok, cual es tu mail de MercadoPago?")
                else
                  error_msg = JSON.parse(response.body)["message"] rescue " "
                  client.say(channel: data.channel, text: "#{response.code} #{response.message} : #{error_msg}") 
                end 
              end
            end
          
          rescue Exception => e 
            client.say(channel: data.channel, text: e.message)
            client.say(channel: data.channel, text: e.backtrace)
          end
        elsif sentiment_analysis != nil
          
          uri_trasnlate = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160713T211117Z.250bd295ce2d1043.e4530217cbbab3ee462d241ecb1ae5887ac505fd&text=#{sentiment_analysis[:prhase].gsub(' ', '+')}&lang=es-en"
          
          file = open(uri_trasnlate)
          
          result = JSON.parse(file.read)
          
          puts "RESULT: #{result.inspect}"
          
          trasnlated = result["text"].join(" ")
          
          uri = URI.parse("https://twinword-sentiment-analysis.p.mashape.com/analyze/")
          
          request = Net::HTTP::Post.new(uri)
          request.content_type = "application/x-www-form-urlencoded"
          request["X-Mashape-Key"] = "hubWV8Cbqdmsh2JNt6GGT7JygXPep12RcTdjsnGwx4WV1fz1wg"
          request["Accept"] = "application/json"
          request.body = "text=#{trasnlated}"
          
          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
            http.request(request)
          end
          
          
          
          result = JSON.parse(response.body)
          
          puts "RESULT: #{result.inspect}"
          
          client.say(channel: data.channel, text: %Q(#{result["type"]} - #{result["score"]})) 
          
        elsif pokemon != nil
          
          file = open("http://pokeapi.co/api/v2/pokemon/#{pokemon[:pokemon]}")
            
          result = JSON.parse(file.read)
          
          desc = %Q(Abilities: #{result["abilities"].map{|item| item["ability"]["name"]}.join(", ")} \n Peso: #{result["weight"]} \n "Altura: #{result["height"]} \n Tipos: #{result["types"].map{|item| item["type"]["name"]}.join(", ")}")
          
          client.web_client.chat_postMessage(
              channel: data.channel,
              as_user: true,
              attachments:  [
                              {
                                title: pokemon[:pokemon],
                                thumb_url: result["sprites"]["front_default"],
                                text: desc
                              }
                            ]
          )
          
        elsif panther != nil
          client.say(channel: data.channel, text: "@cris:")
        elsif set_guard_person != nil
          @guardia = set_guard_person[:person]
          
          client.say(channel: data.channel, text: ["Guardado", "Ok!", "Dale"].sample)
        elsif get_guard_person != nil
          
          @guardia ||= "Nadie esta de guardia :white_frowning_face: "
          client.say(channel: data.channel, text: @guardia)
        elsif save_a_number != nil
          @numbers[save_a_number[:person]] = save_a_number[:number]
          client.say(channel: data.channel, text: ["Guardado", "Ok!", "Dale"].sample) 
        elsif send_a_sms != nil
          if @numbers[send_a_sms[:person]] 
            `curl "https://rest.nexmo.com/sms/json?api_key=5674d76d&api_secret=354efe58d01a3b7a&from=NEXMO&to=#{@numbers[send_a_sms[:person]] }&text=#{send_a_sms[:message].split(' ').join('+')}"`
            client.say(channel: data.channel, text: "enviado.")
          else
            client.say(channel: data.channel, text: "No tengo el numero de send_a_sms[:person] :white_frowning_face:")
          end
        elsif wanna_joke != nil
          
          jokes = JSON.parse(File.open(File.dirname(__FILE__) + '/jokes.json').read)
          
          client.say(channel: data.channel, text: "Ok")
          client.say(channel: data.channel, text: jokes.sample["joke"])
        else
          client.say(channel: data.channel, text: bot.say(match[:expression]))
        end
         
      end
      
    end
  end
end