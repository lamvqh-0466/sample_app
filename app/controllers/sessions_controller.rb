class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    if @user&.authenticate params.dig(:session, :password)
      log_in @user
      flash[:success] = t "login_successfull"
      redirect_to user_path(id: @user.id), status: :see_other
    else
      flash.now[:danger] = t "invalid_email_ password_combination"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t "logout_successfull"
    redirect_to static_pages_home_path
  end
end
