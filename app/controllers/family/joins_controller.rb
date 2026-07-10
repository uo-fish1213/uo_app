class Family::JoinsController < ApplicationController
  before_action :require_login

  def new
    @simple_header = true
  end

  def create
    family_code = params[:family_code]
    family = Family.find_by(family_code: family_code)

    if family
      # 既に家族に所属しているかどうかをチェック
      was_already_in_family = current_user.family.present?
      
      current_user.update(family: family)
      
      # 条件によってメッセージを変える
      if was_already_in_family
        flash[:notice] = '家族コードを更新しました'
      else
        flash[:notice] = t('family.joins.updated_successfully')
      end
      redirect_to family_connection_select_path
    else
      flash.now[:alert] = t('family.joins.family_code_not_found')
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  # 既に家族に参加している場合は参加画面にアクセスさせない
  def check_not_joined
    if current_user.family.present?
      redirect_to family_connection_select_path, alert: t('family.joins.already_joined')
    end
  end
end