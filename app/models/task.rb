class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :image

  before_create :set_status_by_default

  validates :image, presence: true

  STATUSES = {
    'new' => 'progress',
    'progress' => 'done'
  }

  def process_image(host, callback)
    result = send_request host, callback
    img_data = result['image']

    if img_data
      change_status
    else
      set_error_status
      self.save!
    end
  end

  def process_result(result)
    image.attachment.download! "#{ENV['PROCESSING_SERVER']}#{result['url']}"
    image.save!

    change_status
    remove_remote_image result['id']
  end

  private
    def set_status_by_default
      self.status = 'new'
    end

    def set_error_status
      self.status = 'error'
    end

    def change_status(save = true)
      status = STATUSES[self.status]

      if status.nil?
        set_error_status
      else
        self.status = status
      end

      self.save! if save
    end

    def send_request(host, callback)
      request_ctrl = RequestsController.new host: ENV['PROCESSING_SERVER']

      request_params = {
        picture: URI.parse("#{host}#{image.attachment.url}"),
        callback: callback
      }.merge!(JSON.parse(self.params))

      request_ctrl.post('/images', request_params)
    end

    def remove_remote_image(id)
      RequestsController.new(host: ENV['PROCESSING_SERVER']).delete("/images/#{id}")
    end

end
