class ApplicationController < ActionController::Base
  protect_from_forgery

def set_carriers
    @carriers = ["Verizon", "AT&T", "T-Mobile", "Boost Mobile", "Sprint", "Virgin Mobile"]
  end
end
