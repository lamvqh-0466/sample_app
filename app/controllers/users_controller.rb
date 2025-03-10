class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all, items: Settings.user.pagy_items)
  end

  def show
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

  def edit; end

  def update
    if @user.update(users_params)
      flash[:success] = t "update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "update_fail"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "delete_success"
    else
      flash[:danger] = "delete_fail"
    end
    redirect_to users_path
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to static_pages_home_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "need_login"
    redirect_to login_path
  end

  def users_params
    params.require(:user).permit(User::ATTRIBUTES)
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t "not_user"
    redirect_to static_pages_home_path
  end

  def admin_user
    redirect_to static_pages_home_path unless current_user.admin?
  end
end
