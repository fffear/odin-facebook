class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :post, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_index :likes, %i(post_id user_id), unique: true    
  end
end
