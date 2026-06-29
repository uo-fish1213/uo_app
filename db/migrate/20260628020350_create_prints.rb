class CreatePrints < ActiveRecord::Migration[7.1]
  def change
    create_table :prints do |t|
      t.references :user, null: false, foreign_key: true
      t.string :image
      t.integer :child_tag, null: false, default: 0
      t.integer :action_tag, null: false, default: 0
      t.date :deadline

      t.timestamps
    end
  end
end
