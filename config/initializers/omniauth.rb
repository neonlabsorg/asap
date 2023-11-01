Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :developer if Rails.env.development?
  provider  :openid_connect,
            scope: ['openid', 'profile', 'email'],
            issuer: "https://#{ENV["OIDC_HOSTNAME"]}/adfs",
            extra_authorize_params: { resource: 'urn:microsoft:userinfo' },
            discovery: true,
            client_options: {
              port: 443,
              scheme: 'https',
              host: ENV["OIDC_HOSTNAME"],
              authorization_endpoint: "https://#{ENV["OIDC_HOSTNAME"]}/adfs/oauth2/authorize",
              token_endpoint: "https://#{ENV["OIDC_HOSTNAME"]}/adfs/oauth2/token",
              userinfo_endpoint: "https://#{ENV["OIDC_HOSTNAME"]}/adfs/userinfo",
              identifier: ENV["OIDC_IDENTIFIER"],
              secret: ENV["OIDC_SECRET_KEY"],
              redirect_uri: "https://#{ENV["HOSTNAME"]}/auth/openid_connect/callback"
            }
end
