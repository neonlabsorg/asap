class ActiveDirectory
    tls_options = {
      method: :simple_tls,
      tls_options: {
        ssl_version: 'TLSv1_2',
        verify_mode: OpenSSL::SSL::VERIFY_PEER
      }
    }
    @ldap = Net::LDAP.new host: Rails.application.credentials.ad[:dc],
                          port: 636,
                          connect_timeout: 10,
                          encryption: tls_options
  
    def self.authenticate
      @ldap.auth Rails.application.credentials.ad[:username], Rails.application.credentials.ad[:password]
      return @ldap if @ldap.bind
    end
  end
  