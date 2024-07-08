require 'csv'

class Alert < ApplicationRecord
  belongs_to :assignee, class_name: 'alert', foreign_key: :assignee_id, optional: true

  validates :source, presence: true

  ALERT_ORDERED = ['Critical', 'High', 'Medium', 'Low']

  def self.order_by_case
    ret = "CASE"
    ALERT_ORDERED.each_with_index do |p, i|
      ret << " WHEN severity = '#{p}' THEN #{i}"
    end
    ret << " END ASC"
  end

  scope :by_severity, -> { order(Arel.sql(order_by_case)) }

  def self.get_csv(alerts)
    CSV.generate do |csv|
      csv << ["Title", "Assets"]

      alerts.each do |alert|
        csv << [alert.title, alert.asset]
      end
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["asset", "source", "title", "hide_responded", "history_mode"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # this ransacker is created to make "Hide alerts containing issue" working. Do not remove!
  ransacker :hide_responded, formatter: proc { |v| v == true } do |parent|
    # Arel.sql("alerts.issue IS NOT NULL AND alerts.issue != ''")
  end

  # this ransacker is created to make "Switch to history mode" working. Do not remove!
  ransacker :history_mode, formatter: proc { |v| v == false } do |parent|
    # pass
  end

end
