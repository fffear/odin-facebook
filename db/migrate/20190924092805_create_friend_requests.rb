class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.references :requester
      t.references :requestee
      t.timestamps
    end

    add_index :friend_requests, [:requestee_id, :requester_id], unique: true
  end
end
