class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :image

  before_create :set_status_by_default

  STASUSES = {
    'new' => 'progress',
    'progress' => 'done'
  }

  def change_status
    status = STASUSES[self.status]

    if status.nil?
      set_error_status
    else
      self.status = status
    end
  end

  private
    def set_status_by_default
      self.status = 'new'
    end

    def set_error_status
      self.status = 'error'
    end

    def proccess_image

    end

end
