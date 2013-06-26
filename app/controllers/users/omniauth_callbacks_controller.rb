class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      # @after_sign_in_url = after_sign_in_path_for(@user)
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      # render 'callback', :layout => false

      # # if params[:state] == 'popup'
      # #   render 'callback', :layout => false
      # # else
      # #   redirect_to @after_sign_in_url
      # # end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end