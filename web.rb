require 'sinatra/base'

module PulpoBot
  
  MercadoPago::Settings.ACCESS_TOKEN  = "TEST-3964826791704277-042213-a8239945016c46f25a87aafebd74bab3__LD_LB__-202809963"
  
  class Web < Sinatra::Base
    get '/' do
      'PulpoBot Ready!'
    end
  end
end