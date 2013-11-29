class ApplicationController < ActionController::Base
  protect_from_forgery

before_filter :authenticate

protected

def authenticate
  authenticate_or_request_with_http_basic do |username, password|
    username == "jryoo" && password == "hello123"
  end
end

def set_carriers
    @carriers = ["Verizon", "AT&T", "T-Mobile", "Boost Mobile", "Sprint", "Virgin Mobile"]
  end
end
