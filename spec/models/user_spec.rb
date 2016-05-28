require 'rails_helper'

RSpec.describe User, type: :model do

  subject { build(:user) }

  it { should respond_to(:email) }
  it { should respond_to(:name) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_length_of :email }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_length_of :name }
    it { is_expected.to validate_length_of :password }
  end

  describe 'associations' do
    it { is_expected.to have_many :sessions }
    it { is_expected.to have_many :images }
  end

end
