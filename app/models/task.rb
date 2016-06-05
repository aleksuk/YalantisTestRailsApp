require 'net/http'
require 'uri'

class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :image

  before_create :set_status_by_default

  validates :image_id, presence: true

  STASUSES = {
    'new' => 'progress',
    'progress' => 'done'
  }

  PROCESSING_SERVER_HOST = 'http://localhost:9292'

  def change_status(save = true)
    status = STASUSES[self.status]

    if status.nil?
      set_error_status
    else
      self.status = status
    end

    self.save! if save
  end

  def process_image(host)
    Thread.new do
      change_status
      response = send_request(host)

      if response.code == 200
        process_response(response)
      else
        set_error_status
      end

      self.save!
    end
  end

  private
    def set_status_by_default
      self.status = 'new'
    end

    def set_error_status
      self.status = 'error'
    end

    def send_request(host)
      HTTP.post("#{PROCESSING_SERVER_HOST}/images", form: {
        picture: URI.parse("#{host}#{image.attachment.url}"),
        effect: 'negate'
      })
    end

    def process_response(response)
      result = JSON.parse(response.to_s)
      image_url = result.dig('image', 'url')

      update_image(image_url)

      self.change_status
      # self.remove_image_from_processing_server(result.dig('image', 'id'))
    end

    def update_image(image_url)
      # TODO: Image isn't updated in the first time
      image.update!(remote_attachment_url: "#{PROCESSING_SERVER_HOST}#{image_url}")
      image.remote_attachment_url = "#{PROCESSING_SERVER_HOST}#{image_url}"
      image.save!
    end

    def remove_image_from_processing_server(image_id)
      Thread.new do
        HTTP.delete("#{PROCESSING_SERVER_HOST}/images/#{image_id}").to_s
      end
    end

end
