# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
NOLAsafewater::Application.initialize!


Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.gmail.com",
                           :port      => 587,
                           :domain    => "google.com",
                           :user_name => "nolaswnotice@gmail.com",
                           :password  => "alternativebreaks",
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
end