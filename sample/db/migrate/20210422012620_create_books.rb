class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, null: false, index: true
      t.string :image_file_name
      t.string :image_file_size
      t.string :image_content_type
      t.string :image_updated_at

      t.timestamps
    end
  end
end
