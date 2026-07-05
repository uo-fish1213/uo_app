class Print < ApplicationRecord
  belongs_to :user

 # 画像アップロード(carrierwave の設定)
  mount_uploader :image, ImageUploader

  # バリデーション
  validates :image, presence: true
  validate :deadline_cannot_be_in_the_past
  validates :action_tag, presence: true
  validates :child_tag, presence: true

  enum :child_tag, [:first_child, :second_child, :third_child, :fourth_child]
  
  enum :action_tag, [:submit, :prepare, :payment, :event, :read_only]
  
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

  private

  def deadline_cannot_be_in_the_past
    if deadline.present? && deadline < Date.today
      errors.add(:deadline, 'に過去の日付を設定することはできません')
    end
  end
end
