class Family < ApplicationRecord
  before_create :generate_family_code

  has_many :users, dependent: :nullify

  # バリデーション
  validates :family_code, presence: true, uniqueness: true
  
  # 家族のプリントを取得するメソッド
  def prints
    Print.where(user_id: users.select(:id))
  end

  private

  def generate_family_code
    loop do
      self.family_code = SecureRandom.alphanumeric(8).upcase
      break unless Family.exists?(family_code: family_code)
    end
  end
end