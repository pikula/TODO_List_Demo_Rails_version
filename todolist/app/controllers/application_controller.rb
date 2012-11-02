class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_time_zone

 def set_time_zone
    #current user is a devise method see https://github.com/plataformatec/devise
    Time.zone = current_user.time_zone if current_user
 end
end
