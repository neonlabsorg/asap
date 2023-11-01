# require 'auth_ldap'
class User < ApplicationRecord
  has_many :alerts, foreign_key: :assignee_id

  # def self.authenticate(username, password)
  #   username = username.downcase
  #   user = User.find_by(username: username)
  #   if user
  #     auth_ldap = AuthLDAP.new # (LDAP_CONFIG)

  #     if auth_ldap.authenticate(username, password) == true
  #       user
  #     else
  #       false
  #     end
  #   else
  #     false
  #   end
  # end
end