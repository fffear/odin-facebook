class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :author, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
