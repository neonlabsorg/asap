class CreateIpAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :ip_addresses do |t|
      t.string :ip
      t.string :description

      t.timestamps
    end
  end
end
