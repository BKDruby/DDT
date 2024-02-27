module Api
  class ApiBaseController < ApplicationController
    protect_from_forgery with: :null_session
    rescue_from Exception, with: :render_error

    def render_error(error)
      render json: { error: error.message }, status: 422
    end
  end
end
