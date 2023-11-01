class AddResurfacedToAlerts < ActiveRecord::Migration[7.0]
  def change
    add_column :alerts, :resurfaced, :boolean, default: false
  end
end
