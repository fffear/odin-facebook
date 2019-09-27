class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.integer :requester_id, null: false
      t.integer :requestee_id, null: false
      t.timestamps
    end

    add_index :friendships, %i(requestee_id requester_id), unique: true
    add_index :friendships, :requester_id
  end
end
