class Api::UsersController < Api::BaseController
  skip_before_action :auth_user, only: :create
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    render_response @users
  end

  def show
    render_response @user
  end

  def create
    user = User.create! new_user_params
    session = user.sessions.create

    render_response session, 201
  end

  def update
    @user.update! user_params
    render_response @user, 200
  end

  def destroy
    @user.destroy

    render_response nil, 204
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :name)
    end

    def new_user_params
      params.permit(
        :email,
        :name,
        :password,
        :password_confirmation
      )
    end
end
