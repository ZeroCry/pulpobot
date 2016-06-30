require 'sinatra/base'

module PulpoBot
  class Web < Sinatra::Base
    get '/' do
      'Pulpo Responde'
    end
  end
end