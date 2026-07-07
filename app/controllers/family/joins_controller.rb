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
end