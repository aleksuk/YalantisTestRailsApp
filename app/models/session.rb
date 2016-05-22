class Session < ActiveRecord::Base
  belongs_to :user

  before_create :generate_token

  MINUTES_20 = 1200000

  validates :user, presence: true

  def self.authenticate_by_credentials(email, password)
    user = User.find_by(email: email).try(:authenticate, password)
    raise UnauthorizedError.new unless user

    self.remove_old_sessions user
    self.create_session user
  end

  def self.authenticate_by_token(token)
    session = self.find_by token: token
    raise UnauthorizedError.new unless session

    session
  end

  protected
    def self.create_session(user)
      Session.create! user: user
    end

    def self.remove_old_sessions(user)
      user.sessions.each do |session|
        session destroy! if session.created_at + MINUTES_20 < Date.new
      end
    end

  private
    def generate_auth_token
      SecureRandom.uuid.gsub(/\-/,'')
    end

    def generate_token
      token = generate_auth_token

      while Session.find_by token: token
        token = generate_auth_token
      end

      self.token = token
    end

end
