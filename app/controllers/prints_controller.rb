class PrintsController < ApplicationController
  before_action :require_login  # ← 全アクションでログインを必須にする
  
  # プリント一覧画面の表示
  def index
    @prints = Print.order(created_at: :desc)
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
    @print = Print.new(print_params)
    
    if @print.save
      redirect_to prints_path, notice: 'プリントを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def print_params
    params.require(:print).permit(:image, :deadline, :action_tag, child_ids: [])
  end
end