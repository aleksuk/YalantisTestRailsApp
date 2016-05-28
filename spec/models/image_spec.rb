require 'rails_helper'

RSpec.describe Image, type: :model do

  subject { build(:image) }

  it { should respond_to(:attachment) }

  describe 'associations' do
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    context '#attachment' do
      it 'can\'t be empty' do
        image = build(:image, attachment: nil)

        expect(image).not_to be_valid
      end
    end
  end

end
