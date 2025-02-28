class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to static_pages_home_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      log_in @user
      flash[:success] = Settings.user.create_successfull
      redirect_to @user
    else
      flash.now[:danger] = t "submit_fail"
      render :new, status: :unprocessable_entity
    end
  end
  private
  def users_params
    params.require(:user).permit(User::ATTRIBUTES)
  end
end
