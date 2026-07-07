class Family::CodesController < ApplicationController
  before_action :require_login

  # 家族コード発行画面
  def new
    @family = current_user.family || Family.new
  end
  
  # 家族コード発行処理
  def create
    # コード発行処理
  end
end