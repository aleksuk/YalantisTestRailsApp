class Api::ImagesController < Api::BaseController
  before_action :set_image, only: [:show, :update, :destroy]

  IMAGES_PER_PAGE = 20

  def index
    @images = current_user.images.page(page).per(IMAGES_PER_PAGE)
    render_response @images
  end

  def create
    @image = current_user.images.create!(image_params)

    task = current_user.tasks.create!(image: @image, params: task_params)
    task.process_image(request.base_url)

    render_response @image, 201
  end

  def show
    render_response @image
  end

  def update
    @image.update!(image_params)

    render_response @image
  end

  def destroy
    @image.destroy

    render_response nil, 204
  end

  private
    def image_params
      params.permit(:attachment)
    end

    def task_params
      params.permit(:params)
    end

    def page
      params[:page] || 1
    end

    def set_image
      @image = Image.find(params[:id])
    end

end
