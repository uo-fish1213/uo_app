class Family::ConnectionsController < ApplicationController
  before_action :require_login
  before_action :check_family_exists, only: [:create]
  # 家族連携画面（選択画面）
  def select
    # 家族の有無によって表示を切り替える画面
  end
  
  # 家族コード発行画面
  def new
    @family = Family.new
  end
  
  # 家族コード発行処理
  def create
    # 新しい家族を作成し、ユニークなコードを生成
    @family = Family.new(family_code: generate_family_code)
    
    if @family.save
      # 作成した家族にユーザーを紐付け
      current_user.update(family: @family)
      redirect_to family_connection_select_path, 
          success: t('family.connections.create.success')
    else
      flash.now[:danger] = t('family.connections.create.failure')
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  # 既に家族に参加している場合は発行画面にアクセスさせない
  def check_family_exists
    if current_user.family.present?
      redirect_to family_connection_select_path, 
                  warning: '既に家族コードを発行済みです'
    end
  end
  
  # ユニークな家族コードを生成
  def generate_family_code
    loop do
      code = SecureRandom.alphanumeric(8).upcase
      break code unless Family.exists?(family_code: code)
    end
  end
end