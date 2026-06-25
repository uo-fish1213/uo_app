class ApplicationController < ActionController::Base
add_flash_types :success, :dange

# ログインが必要なページで使用
  before_action :require_login, except: [:index]  # トップページは除外

  private

  # ログインしていない場合はログイン画面へリダイレクト
  def not_authenticated
    redirect_to login_path, alert: 'ログインしてください'
  end

end
