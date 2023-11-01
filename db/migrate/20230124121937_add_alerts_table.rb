class AddAlertsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :alerts, id: :uuid do |t|
      t.string :title, null: false
      t.string :asset, null: false
      t.string :issue
      t.string :severity
      t.boolean :active, default: true
      t.datetime :last_detected_at
      t.datetime :last_closed_at
      t.string :last_closed_by
      t.text :remediation
      t.string :source
      t.string :cve_list, array: true, default: []
      t.text :output
      t.string :nessus_plugin_id
      t.string :dc
      t.uuid :assignee_id

      t.timestamps
    end
  end
end