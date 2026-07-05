class Family::JoinsController < ApplicationController
  # 既存家族コード入力画面
  def new
    @family_code = FamilyCode.new
  end
  
  # 既存コードで参加する処理
  def create
    # コード入力で参加する処理
  end
end