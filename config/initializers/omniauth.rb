Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :developer if Rails.env.development?
  provider  :openid_connect,
            scope: ['openid', 'profile', 'email'],
            issuer: Rails.application.config.oidc_issuer,
            discovery: true,
            client_options: {
              port: 443,
              scheme: 'https',
              host: Rails.application.config.oidc_hostname,
              authorization_endpoint: Rails.application.config.oidc_authorization_endpoint,
              token_endpoint: Rails.application.config.oidc_token_endpoint,
              userinfo_endpoint: Rails.application.config.oidc_userinfo_endpoint,
              identifier: Rails.application.config.oidc_identifier,
              secret: Rails.application.config.oidc_secret,
              redirect_uri: Rails.application.config.oidc_redirect_uri
            }
end
