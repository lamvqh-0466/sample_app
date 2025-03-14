class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "flash_create_infor"
      redirect_to static_pages_home_path
    else
      flash.now[:danger] = t "flash_create_danger"
      render :new
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t("error")
      render :edit
    elsif @user.update(user_params)
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "reset_password_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]

    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to static_pages_home_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_expired"
    redirect_to new_password_reset_url
  end

  def valid_user
    return if @user.authenticated?(:reset, params[:id]) && @user.activated?

    flash[:danger] = t "in_activate"
    redirect_to static_pages_home_path
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
