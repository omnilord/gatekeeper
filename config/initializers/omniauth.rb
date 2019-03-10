Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discord,
           Rails.application.credentials.dig(:discord, :id),
           Rails.application.credentials.dig(:discord, :client_secret),
           scope: 'identify email guilds'
  OmniAuth.config.on_failure = -> (env) do
    Rack::Response.new(['302 Moved'], 302, 'Location' =>  '/').finish
  end
end
