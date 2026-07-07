class Family::JoinsController < ApplicationController
  before_action :require_login

  def new
    # 家族コード入力画面を表示
  end

  def create
    family = Family.find_by(family_code: params[:family_code])

    if family
      current_user.update(family: family)
      redirect_to root_path, notice: '家族コードで連携しました'
    else
      flash.now[:alert] = '家族コードが見つかりませんでした'
      render :new
    end
  end
end