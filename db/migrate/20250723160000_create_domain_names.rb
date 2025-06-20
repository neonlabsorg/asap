class CreateDomainNames < ActiveRecord::Migration[7.1]
  def change
    create_table :domain_names do |t|
      t.string :domain

      t.timestamps
    end
  end
end 