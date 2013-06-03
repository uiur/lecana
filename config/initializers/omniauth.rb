Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Settings.twitter_key, Settings.twitter_secret
  provider :facebook, Settings.facebook_key, Settings.facebook_secret, {:scope => "publish_stream"}
  #provider :facebook, "", "", {:scope => "publish_stream"}
end
