class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:tomorrow_requests]
  before_action :web_api, :init_exchange
  helper_method :background_color

  def web_api
  	"http://webapi.enduraproducts.com/api/endura/"
  end

  def init_exchange
  	@exchange_server = Exchange.new('https://ncmail1.enduraproducts.com/ews/Exchange.asmx', 'notifications', '3ndur@notification')
  end
  
  def background_color(month)
  	current_month = Date.today.strftime("%m").to_i

  	case 
  	when month.to_i < current_month
  		"#D63E4B"
  	else
  		"#CFEDB9"
  	end
  end
end
