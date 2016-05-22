class Image < ActiveRecord::Base
  belongs_to :user
  mount_uploader :attachment, ImageUploader

  validate :check_attachment

  private
    def check_attachment
      if attachment.url.nil?
        errors.add(:attachment, 'invalid image url')
      end
    end

end
