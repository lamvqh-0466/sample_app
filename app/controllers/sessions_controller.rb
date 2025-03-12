class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user&.authenticate(params.dig(:session, :password))
      forwarding_url = session[:forwarding_url]
      if @user.activated?
        handle_login(forwarding_url)
      else
        flash.now[:warning] = t "account_not_activated"
        render :new, status: :unprocessable_entity
      end
    else
      handle_failed_login
    end
  end

  def destroy
    log_out
    flash[:success] = t "logout_successfull"
    redirect_to static_pages_home_path
  end

  private

  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def handle_login forwarding_url
    log_in @user
    handle_remember_me
    flash[:success] = t "login_successfull"
    redirect_to forwarding_url || user_path(id: @user.id), status: :see_other
  end

  def handle_failed_login
    flash.now[:danger] = t "invalid_email_password_combination"
    render :new
  end

  def handle_remember_me
    if params.dig(:session, :remember_me) == "1"
      remember(@user)
      redirect_back_or user_path(id: user.id)
    else
      forget(@user)
    end
  end
end
