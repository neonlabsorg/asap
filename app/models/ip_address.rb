class IpAddress < ApplicationRecord
  validates :ip, presence: true, uniqueness: true
  validates :ip, format: { with: /\A(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/,
                          message: "must be a valid IPv4 address" }

  def self.ransackable_attributes(auth_object = nil)
    ["ip"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
                        
end
