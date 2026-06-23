class Family < ApplicationRecord
  # 関連付け
  has_many :users, dependent: :nullify

  # バリデーション
  validates :family_code, presence: true, uniqueness: true
  
end