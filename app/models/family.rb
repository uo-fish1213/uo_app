class Family < ApplicationRecord
  # 関連付け
  has_many :users, dependent: :nullify

  # バリデーション
  validates :family_code, presence: true, uniqueness: true
  
  def generate_family_code
    loop do
      self.family_code = SecureRandom.alphanumeric(8).upcase
      break unless Family.exists?(family_code: family_code)
    end
  end
end