require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(attributes_for(:user))
  end

  after do
    @user.destroy!
  end

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:name) }

  describe "#email" do
    it "can't be empty" do
      @user.email = ''
      expect(@user).not_to be_valid
    end

    it "can't be longer than 30 characters" do
      email_str = ''

      30.times { email_str += 's'}
      email_str += '@mail.com'

      @user.email = email_str
      expect(@user).not_to be_valid
    end

    it "can't have invalid format" do
      @user.email = 'asdffsd.sfds'
      expect(@user).not_to be_valid
    end

    it "should be unique" do
      @user.save!

      new_user = User.new(attributes_for(:user))
      expect(new_user).not_to be_valid
    end
  end

  describe "#name" do
    it "can't be empty" do
      @user.name = ''
      expect(@user).not_to be_valid
    end

    it "can't be longer than 30 characters" do
      name_str = ''

      31.times { name_str += 's'}

      @user.name = name_str
      expect(@user).not_to be_valid
    end
  end
end
