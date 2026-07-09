class UsersController < ApplicationController
   # ユーザー登録だけはログイン不要
  before_action :require_login, except: [:new, :create]

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
        auto_login(@user)  # 自動ログイン
        redirect_to prints_path, success: 'ユーザー登録が完了しました'
      else
        flash.now[:danger] = 'ユーザー登録に失敗しました'
        render :new, status: :unprocessable_entity
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation, :family_code)
  end
end