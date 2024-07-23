class Lifetime < ApplicationRecord
  validates :source, presence: true, uniqueness: true
  validates :alert_lifetime_days, presence: true, numericality: { only_integer: true, greater_than: 0 }

end
