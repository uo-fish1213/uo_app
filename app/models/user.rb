class User < ApplicationRecord
  authenticates_with_sorcery!
  
  # 関連付け
  belongs_to :family, optional: true
  
  # バリデーション
  validates :email, presence: true, uniqueness: true
  validates :user_name, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  
  # メソッド
  def family_member?
    family.present?
  end
end