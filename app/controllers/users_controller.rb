class UsersController < ApplicationController

  before_action :set_users, only: [:show, :edit, :update_info, :update_password]

  before_action :authenticate_user!
  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update_info
    if current_user.update(user_info_params)
      redirect_to user_path(@user)
      flash[:success] = 'Successfully Updated'
    else
      render 'edit'
      flash[:warning] = current_user.display_error_messages
    end
    # redirect_to edit_profile_path
  end

  def get_password
  end

  def update_password
    if current_user.valid_password?(user_password_params[:current_password])
      if current_user.chg_password(user_password_params)
        #sign_in(current_user, bypass: true)
        bypass_sign_in(current_user)
        flash[:success] = 'Password Changed Successfully'
      else
        flash[:danger] = current_user.display_error_messages
      end

    else
      flash[:danger] = 'Incorrect Password' #current_author.errors.full_messages.join('. ') << '.'
    end
    redirect_to user_path(@user)
  end

  private


  def set_users
    @user = User.friendly.find(params[:id])
  end

  def user_info_params
    params.require(:user).permit(:name, :email, :bio, :address, :profile_picture)
  end

  def user_password_params
    params.require(:user).permit(:current_password, :new_password, :new_password_confirmation)
  end



end

