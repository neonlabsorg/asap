class DomainName < ApplicationRecord
  validates :domain, presence: true, uniqueness: true
  validates :domain, format: { with: /\A(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}\z/, message: "must be a valid domain name" }

  def self.ransackable_attributes(auth_object = nil)
    ["domain"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

end