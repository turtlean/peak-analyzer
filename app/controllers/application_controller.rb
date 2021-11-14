class ApplicationController < ActionController::Base
  # There's currently no authentication for the API.
  # TODO: Add proper authentication and delete this line
  skip_before_action :verify_authenticity_token
end
