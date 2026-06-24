class User < ApplicationRecord
  authenticates_with_sorcery!

  # 関連付け
  belongs_to :family, optional: true

  # 仮想属性として family_code を定義
  attr_accessor :family_code

  # バリデーション
  # メールアドレスのバリデーション
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: true

  # ユーザー名のバリデーション
  validates :user_name, presence: true, length: { minimum: 2, maximum: 20 }

  # パスワードのバリデーション（Sorcery用）
  validates :password, length: { minimum: 8 },
                       format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i,
                                 message: "は英字と数字の両方を含めてください" },
                       if: -> { new_record? || changes[:crypted_password] }

  # パスワード確認のバリデーション（Sorcery用）
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # family_code が入力されている場合のみ検証
  validate :validate_family_code, if: -> { family_code.present? }

  private
  
  def validate_family_code
    family = Family.find_by(code: family_code)
    if family.nil?
      errors.add(:family_code, 'に誤りがあります')
    else
      self.family_id = family.id  # 既存の家族に紐付け
    end
  end
end