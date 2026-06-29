class Print < ApplicationRecord
  belongs_to :user

 # 画像アップロード
  mount_uploader :image, ImageUploader

  # バリデーション
  validates :image, presence: true
  validates :deadline, presence: true
  validates :action_tag, presence: true
  validates :child_tag, presence: true

  enum child_tag: {
    first_child: 0,
    second_child: 1,
    third_child: 2,
    fourth_child: 3
  }
  
  enum action_tag: {
    submit: 0,
    prepare: 1,
    payment: 2,
    event: 3,
    read_only: 4
  }
  
   # 表示名を返すメソッド
  def child_tag_i18n
    I18n.t("enums.print.child_tag.#{child_tag}")
  end
  
  def action_tag_i18n
    I18n.t("enums.print.action_tag.#{action_tag}")
  end
  
  # セレクトボックス用
  def self.child_tags_for_select
    child_tags.keys.map do |key|
      [I18n.t("enums.print.child_tag.#{key}"), key]
    end
  end
  
  def self.action_tags_for_select
    action_tags.keys.map do |key|
      [I18n.t("enums.print.action_tag.#{key}"), key]
    end
  end
end
