class Family::CodesController < ApplicationController
  # 家族コード発行画面
  def new
    @family_code = FamilyCode.new
  end
  
  # 家族コード発行処理
  def create
    # コード発行処理
  end
end