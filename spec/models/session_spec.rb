require 'rails_helper'

RSpec.describe Session, type: :model do

  before do
    @user_email = Faker::Internet.email
    @user_password = Faker::Internet.password

    @user = create(:user, email: @user_email, password: @user_password)
  end

  after do
    Session.destroy_all
    @user.destroy
  end

  subject { build(:session) }

  it { should respond_to(:token) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :user }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
  end

  describe '#token' do
    it 'should generate secure token' do
      subject.user = @user

      expect(subject).to receive(:generate_token).and_call_original
      expect { subject.save }.to change { subject.token }

      subject.destroy
    end
  end

  describe '#authenticate_by_credentials' do
    it 'should raise UnauthorizedError' do
      email = Faker::Internet.email
      password = Faker::Internet.password

      expect { Session.authenticate_by_credentials(email, password) }.to raise_error(UnauthorizedError)
    end

    it 'should create new session' do
      expect(Session).to receive(:create_session).with(@user)

      Session.authenticate_by_credentials(@user_email, @user_password)
    end
  end

  describe '#authenticate_by_token' do
    it 'should raise UnauthorizedError' do
      token = SecureRandom.uuid.gsub(/\-/,'')

      expect { Session.authenticate_by_token(token) }.to raise_error(UnauthorizedError)
    end

    it 'should return available session' do
      user = create(:user)
      session = create(:session, user: user)

      expect(Session.authenticate_by_token(session.token)).to eq(session)
    end
  end

  describe '#create_session' do
    it 'should return new session' do
      session = Session.create_session(@user)

      expect(session).to be_kind_of Session
    end
  end

  describe '#generate_token' do
    it 'should return token' do
      token = SecureRandom.uuid.gsub(/\-/,'')
      allow(subject).to receive(:generate_auth_token).and_return(token)

      expect(subject.send(:generate_token)).to eq(token)
    end
  end

end
