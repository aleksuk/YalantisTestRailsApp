class Api::ImagesController < Api::BaseController

  IMAGES_PER_PAGE = 20

  def index
    @images = current_user.images.page(page).per(IMAGES_PER_PAGE)
    render_response @images
  end

  def create
    @image = current_user.images.create!(image_params)
    render_response @image, 201
  end

  private
    def image_params
      params.permit(:attachment)
    end

    def page
      params[:page] || 1
    end

end
