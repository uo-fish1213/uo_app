class Family::ConnectionsController < ApplicationController
  before_action :require_login
  
  # 家族連携画面（選択画面）
  def select
  end
  
  # 家族コード発行画面
  def new_code
    @family_code = FamilyCode.new
  end
  
  # 家族コード発行処理
  def create_code
    @family_code = current_user.create_family_code
    if @family_code.save
      redirect_to some_path, notice: '家族コードを発行しました'
    else
      render :new_code
    end
  end
  
  # 既存家族コード入力画面
  def enter_code
    @family_code = FamilyCode.new
  end
  
  # 既存コードで参加する処理
  def join
    # コードを使って家族に参加する処理
  end
end