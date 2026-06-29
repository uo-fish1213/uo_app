class SessionsController < ApplicationController
  skip_before_action :require_login  # SessionsController では認証をスキップ
  
  def new
    # ログインフォームを表示
  end

  def create
    # ログイン処理
    @user = login(params[:email], params[:password])
    
    if @user
      redirect_to prints_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # ログアウト処理
    logout
    redirect_to login_path, notice: 'ログアウトしました'
  end
end