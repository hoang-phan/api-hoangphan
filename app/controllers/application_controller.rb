class ApplicationController < ActionController::API
  protected
  
    def set_default_response_format
      request.format = :json
    end
end
