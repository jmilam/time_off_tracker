class Users::SessionsController < Devise::SessionsController
  layout 'devise'
  require 'net/ldap'
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    username = "Endura\\#{params[:user][:email]}"
    ldap = Net::LDAP.new 
    ldap.host = "192.168.1.37"
    ldap.port = 389
    ldap.base = "CN=Administrator,CN=Users,DC=endura,DC=enduraproducts,DC=com"
    ldap.auth username, params[:user][:password]

    if ldap.bind
      @user = User.find_by_email("#{params[:user][:email]}@enduraproducts.com")
      if @user.nil?
        flash[:error] = "Username or Password is incorrect."
        redirect_to new_user_session_path
      else
        flash[:notice] = "Welcome #{params[:user][:email]}!"
        sign_in(:user, @user)
        redirect_to user_portal_index_path
      end
    else
      flash[:error] = "#{ldap.get_operation_result.message}"
      redirect_to new_user_session_path
    end
    #super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
