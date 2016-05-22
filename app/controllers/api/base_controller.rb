class Api::BaseController < ApplicationController
  attr_reader :session

  before_action :auth_user
  skip_before_filter :verify_authenticity_token

  rescue_from UnauthorizedError do |e|
    render_error({ message: 'Invalid session' }, 401)
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_error({ message: 'Not found' }, 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render_error(e.record.errors, 422)
  end

  def render_response(data, status = 200)
    render_json data, status
  end

  def render_error(data, status = 400)
    render_json data, status
  end

  protected
    def auth_user
      authenticate_with_http_token do |token|
        @session = Session.authenticate_by_token(token)
      end
    end

    def current_user
      @session.try(:user)
    end

    def render_json(data, status)
      render json: data, status: status
    end

end
