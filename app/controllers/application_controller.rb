class ApplicationController < ActionController::Base
  # rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
  #   render :text => exception, :status => 500
  # end
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, except: [:tomorrow_requests]
  before_action :web_api, :init_exchange, :current_user
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
