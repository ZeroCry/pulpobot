require 'sinatra/base'

module PulpoBot
  class Web < Sinatra::Base
    get '/' do
      'PulpoBot Ready!'
    end
  end
end