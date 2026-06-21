class CreatePrints < ActiveRecord::Migration[7.1]
  def change
    create_table :prints do |t|
      t.string :title
      t.text :content
      t.string :print_image
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
