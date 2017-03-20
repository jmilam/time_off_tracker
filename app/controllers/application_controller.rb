class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :web_api

  def web_api
  	"http://webapi.enduraproducts.com/api/endura/"
  end
end
