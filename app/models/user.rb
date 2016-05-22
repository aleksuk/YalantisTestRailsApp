class User < ActiveRecord::Base
  has_secure_password

  has_many :sessions
  has_many :images

  validates :name, presence: true,
                   length: { maximum: 30 }

  validates :email, presence: true,
                    uniqueness: true,
                    length: { maximum: 30 },
                    format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }

  validates :password, length: { minimum: 6 }
end
