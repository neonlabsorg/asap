class AddUsersTable < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, null: false
      t.string :displayname
      t.string :email

      t.timestamps
    end
  end
end
