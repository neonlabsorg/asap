puts "Users sync"
ldap = LdapService.new( 
  Rails.application.config.ldap_host,  
  Rails.application.config.ldap_port, 
  Rails.application.config.ldap_base 
  ) 
if ldap.authenticate( 
  Rails.application.config.ldap_username, 
  Rails.application.config.ldap_password 
  ) 
  ldap.sync_users( 
    Rails.application.config.ldap_users_searchbase, 
    Rails.application.config.ldap_users_filter, 
    Rails.application.config.ldap_attributes_mapping 
  )
end 