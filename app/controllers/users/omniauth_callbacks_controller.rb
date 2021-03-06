class Users::OmniauthCallbacksController < ApplicationController

  # def facebook
  #   @user = User.from_omniauth(request.env["omniauth.auth"])
  #   logger.info request.env["omniauth.auth"]
  #
  #   logger.debug "Inside facebook"
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   #@user = User.from_omniauth(request.env["omniauth.auth"])
  #   logger.debug "User is #{@user}"
  #
  #   if @user.persisted? || @user.save
  #     sign_in_and_redirect @user, :event => :authentication
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #     logger.debug @user.errors.to_a
  #
  #   end
  # end


  def all

    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      session[:user_id] = @user.id
      sign_in_and_redirect @user, notice: "Signed in!"
    else
      # Devise allow us to save the attributes eventhough
      # we havent create the user account yet
      session["devise.user_attributes"] = @user.attributes
      # Because Twitter doesn't provide user's email, it would be nice if we force user to enter it
      # manually on the registration page before we create their account.
      # Here we pass the callback parameter so that we could use it to edit the registration page.
      redirect_to new_user_registration_url(:callback => "twitter")
    end
  end



  def failure
    redirect_to root_path
  end

  alias_method :facebook, :all
  alias_method :twitter, :all
  alias_method :linkedin, :all
  alias_method :github, :all
  alias_method :google_oauth2, :all

end
