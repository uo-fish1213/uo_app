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
      redirect_to prints_path, notice: 'プリントを作成しました'
    else
       # バリデーションエラー時、アップロードされた画像を削除
      @print.remove_image! if @print.image.present?
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @print.update(print_params)
      redirect_to @print, notice: 'プリントを更新しました'
    else
      # 更新失敗時も同様に画像を削除
      @print.reload  # 元の状態に戻す
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def print_params
    params.require(:print).permit(:image, :deadline, :action_tag, child_ids: [])
  end
end