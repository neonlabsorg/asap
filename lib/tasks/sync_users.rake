namespace :sync_users do 
  desc 'Sync users from LDAP' 
  task update: :environment do 
    ldap = LdapService.new( 
      Rails.application.config.ldap_host,  
      Rails.application.config.ldap_port, 
      Rails.application.config.ldap_base 
      ) 
    if ldap.authenticate( 
      Rails.application.config.ldap_username, 
      Rails.application.config.ldap_password 
      ) 
      # Synchronize user accounts 
      ldap.sync_users( 
        Rails.application.config.ldap_users_searchbase, 
        Rails.application.config.ldap_users_filter, 
        Rails.application.config.ldap_attributes_mapping 
      )
    end 
  end 
end