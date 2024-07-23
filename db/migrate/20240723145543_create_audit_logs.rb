class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs do |t|
      t.uuid   :alert_id
      t.text   :event_description

      t.timestamps
    end
  end
end
