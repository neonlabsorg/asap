class DomainName < ApplicationRecord
  validates :domain, presence: true, uniqueness: true
  validates :domain, format: { with: /\A(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}\z/, message: "must be a valid domain name" }
end 