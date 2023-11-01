class LdapService
  def initialize(ldap_host, ldap_port, ldap_base)
    @ldap = Net::LDAP.new(
      host: ldap_host,
      port: ldap_port,
      base: ldap_base,
      connect_timeout: 10,
      encryption: {
        method: :simple_tls,
        tls_options: {
          ssl_version: 'TLSv1_2',
          verify_mode: OpenSSL::SSL::VERIFY_PEER
        }
      }
    )
  end

  def authenticate(username, password)
    @ldap.auth username, password
    return @ldap if @ldap.bind
  end

  def sync_users(searchbase, filter, attrs_mapping)
    attributes = attrs_mapping.values
    active_users = []
    @ldap.search(base: searchbase, filter: filter, attributes: attributes) do |entry|
      id              = GuidSplitterService.unpack_guid(entry[attrs_mapping[:id]].first)
      username        = entry[attrs_mapping[:username]].first&.downcase
      displayname     = entry[attrs_mapping[:displayname]].first
      next if username.nil? || displayname.nil?
      email           = entry[attrs_mapping[:email]]&.first

      active_users << id
      active_user = User.find_or_initialize_by(id: id)
      active_user.assign_attributes(
        username:     username,
        displayname:  displayname,
        email:        email
      )

      active_user.save
    end

    all_users = User.all
    all_users.each do |user|
      user.destroy unless active_users.include?(user.id)
    end
    
  end
end