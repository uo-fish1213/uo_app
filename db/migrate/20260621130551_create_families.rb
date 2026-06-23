class CreateFamilies < ActiveRecord::Migration[7.1]
  def change
    create_table :families do |t|
      t.string :family_code, null: false  
      
      t.timestamps
    end

    add_index :families, :family_code, unique: true  # 重複を防ぐための一意制約
  end
end
