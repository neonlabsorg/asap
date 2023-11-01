require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Asap
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.exceptions_app = self.routes # TO USE CUSTOM 404, 500 pages
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")


    # General configuration
    config.api_token                        = ENV.fetch("API_TOKEN")
    config.db_password                      = ENV.fetch("DB_PASSWORD")

    # Active Directory configuration
    config.ldap_host                        = ENV.fetch("LDAP_HOST")
    config.ldap_port                        = ENV.fetch("LDAP_PORT") { 636 }
    config.ldap_base                        = ENV.fetch("LDAP_BASE")
    config.ldap_username                    = ENV.fetch("LDAP_USERNAME")
    config.ldap_password                    = ENV.fetch("LDAP_PASSWORD")
    config.ldap_users_filter                = ENV.fetch("LDAP_USERS_FILTER") { "(&(objectCategory=Person)(!(UserAccountControl:1.2.840.113556.1.4.803:=2)))" } 
    config.ldap_users_searchbase            = ENV.fetch("LDAP_USERS_SEARCHBASE")
    config.ldap_attributes_mapping          = { 
      id:           :objectGUID, 
      displayname:  :displayName, 
      username:     :sAMAccountName, 
      email:        :userPrincipalName
    }

  end
end
