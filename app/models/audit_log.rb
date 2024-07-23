class AuditLog < ApplicationRecord
  belongs_to :alert, optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["event_description"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

end