# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
NOLAsafewater::Application.initialize!


Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.gmail.com",
                           :port      => 587,
                           :domain    => "google.com",
                           :user_name => "nolaswnotice@gmail.com",
                           :password  => ENV['EMAIL_PASSWORD'],
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
end

Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = 	ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
end