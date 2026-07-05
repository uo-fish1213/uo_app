class PrintsController < ApplicationController
  before_action :require_login  # ← 全アクションでログインを必須にする
  
  # プリント一覧画面の表示(締め切りが近い順に表示)
  def index
    @prints = current_user.prints.order(deadline: :asc)
  end
  
  # プリント詳細画面の表示
  def show
    @print = Print.find(params[:id])
  end
  
  # プリント登録画面の表示
  def new
    @print = Print.new
  end
  
  # プリント登録画面でフォーム送信時の処理
  # (プリント登録画面の実装時に使用)
  def create
   @print = current_user.prints.build(print_params)
    
    if @print.save
      redirect_to prints_path, notice: 'プリントを登録しました'
    else
      flash.now[:danger] = 'プリントの登録に失敗しました'
       # バリデーションエラー時、アップロードされた画像を削除
      @print.remove_image! if @print.image.present?
      render :new, status: :unprocessable_entity
    end
  end

  private
  
  def print_params
    params.require(:print).permit(:image, :child_tag, :action_tag, :deadline)
  end
end