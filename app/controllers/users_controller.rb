
class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:active] == 'false'
      @users = User.deactivated
    else
      @users = User.active
    end
  end

  def new
  end

  def create
    if @user.save
      redirect_to users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user]
      authorize! :edit_users, @user if params[:user][:role]

      if needs_password?(@user, params)
        if @user.update_attributes(user_params)
          sign_in(@user, bypass: true) if @user == current_user
          redirect_to safe_users_path, notice: 'User was successfully updated.'
        else
          render :edit
        end
      else
        params[:user].delete(:password)
        @user.update_without_password(user_params)
        redirect_to safe_users_path, notice: 'User was successfully updated.'
      end
    else
      redirect_to safe_users_path, notice: 'User could not be updated'
    end
  end

  private

  def needs_password?(user, params)
    @user.email != params[:user][:email] ||
      params[:user][:password].present?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :active, :role, :manage_data_sources, :manage_parsers, :manage_harvest_schedules, :manage_link_check_rules, manage_partners: [], run_harvest_partners: [])
  end
end
