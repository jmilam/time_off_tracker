class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :web_api, :init_exchange

  def web_api
  	"http://webapi.enduraproducts.com/api/endura/"
  end

  def init_exchange
  	@exchange_server = Exchange.new('https://ncmail1.enduraproducts.com/ews/Exchange.asmx', 'jmilam', 'jm1010')
  end
end
