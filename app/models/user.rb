class User < ApplicationRecord
  has_many :prints, dependent: :destroy
  authenticates_with_sorcery!

  # 関連付け
  belongs_to :family, optional: true

  # 仮想属性として family_code を定義
  attr_accessor :family_code

  # バリデーション
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: true

  validates :user_name, presence: true, length: { minimum: 2, maximum: 20 }

  validates :password, length: { minimum: 8 },
                       format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i,
                                 message: "は英字と数字の両方を含めてください" },
                       if: -> { new_record? || changes[:crypted_password] }

  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validate :validate_family_code, if: -> { family_code.present? }

  # 家族経由でパートナーのプリントも取得できるように
  def family_prints
    return Print.none unless family
  
    family.prints
  end

  # 家族が変更される前に、ユーザー0の家族コードを破棄
  before_update :destroy_empty_family, if: :will_save_change_to_family_id?

  private
  
  def validate_family_code
    family = Family.find_by(family_code: family_code)  # ここも family_code に統一
    if family.nil?
      errors.add(:family_code, 'に誤りがあります')
    else
      self.family_id = family.id  # 既存の家族に紐付け
    end
  end

  # ユーザーが0人になった家族を削除する
  def destroy_empty_family
    # 変更前の family_id を取得
    old_family_id = family_id_was
    
    # 変更前の家族が存在しない場合は何もしない
    return unless old_family_id
    
    # 変更前の家族を取得
    old_family = Family.find_by(id: old_family_id)
    
    # 古い家族が存在し、自分以外にユーザーがいない場合は削除
    if old_family && old_family.users.where.not(id: id).count.zero?
      old_family.destroy
      Rails.logger.info "Family #{old_family.family_code} was destroyed because it had no users"
    end
  end
end