class CreateLifetimes < ActiveRecord::Migration[7.1]
  def change
    create_table :lifetimes do |t|
      t.string :source, null: false
      t.integer :alert_lifetime_days, null: false

      t.timestamps
    end
  end
end
