class Family::JoinsController < ApplicationController
  before_action :require_login

  def new
     @simple_header = true
  end

  def create
    family_code = params[:family_code]
    family = Family.find_by(family_code: family_code)

    if family
      current_user.update(family: family)
      flash.now[:notice] = t('family.joins.joined_successfully')
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