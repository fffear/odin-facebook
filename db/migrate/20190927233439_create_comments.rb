class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :author, null: false
      t.references :post, null: false

      t.timestamps
    end

    add_index :comments, %i(post_id author_id)
  end
end
