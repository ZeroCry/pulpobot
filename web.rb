require 'sinatra/base'

module PulpoBot
  
  MercadoPago::Settings.ACCESS_TOKEN  = "TEST-6295877106812064-042916-6cead5bc1e48af95ea61cc9254595865__LC_LA__-202809963"
  
  class Web < Sinatra::Base
    get '/' do
      'PulpoBot Ready!'
    end
  end
end