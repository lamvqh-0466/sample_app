class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    activation_token = params[:id]
    if user && !user.activated? && user.authenticated?(:activation,
                                                       activation_token)
      user.activate
      login user
      flash[:success] = t "account_activated"
    else
      flash[:danger] = t "invalid_activation_link"
    end

    redirect_to static_pages_home_path
  end
end
