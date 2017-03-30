class SessionController < ApplicationController
	layout 'devise'
	require 'net/ldap'
	def create
		username = "Endura\\#{params[:session][:username]}"
    ldap = Net::LDAP.new 
    ldap.host = "192.168.1.37"
    ldap.port = 389
    ldap.base = "CN=Administrator,CN=Users,DC=endura,DC=enduraproducts,DC=com"
    ldap.auth username, params[:session][:password]
    
    if ldap.bind
    	authenticate_user(params[:session][:username])
    else
    	flash[:error] = "Username or Password is incorrect."
    	redirect_to new_session_path
    end
	end

	def destroy
		redirect_to new_session_path
	end
end