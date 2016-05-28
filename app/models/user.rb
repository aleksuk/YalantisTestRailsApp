class User < ActiveRecord::Base
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :images, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :email, presence: true,
                    uniqueness: true,
                    length: { maximum: 50 },
                    format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }

  validates :password, length: { minimum: 6 }
end
