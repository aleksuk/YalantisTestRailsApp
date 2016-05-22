class Api::SessionsController < Api::BaseController
  skip_before_action :auth_user, only: :create

  def create
    @session = Session.authenticate_by_credentials(params[:email], params[:password])

    render_response @session, 201
  end

  def destroy
    session.destroy

    render_response nil, 204
  end

end
