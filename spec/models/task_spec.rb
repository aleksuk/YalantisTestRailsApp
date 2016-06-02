require 'rails_helper'

RSpec.describe Task, type: :model do

  subject { build(:task) }

  let(:new_status) { 'new' }
  let(:progress_status) { 'progress' }
  let(:done_status) { 'done' }
  let(:error_status) { 'error' }

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :image }
  end

  describe '#change_status' do
    it 'should change status from new to progress' do
      subject.status = new_status
      subject.change_status

      expect(subject.status).to eq(progress_status)
    end

    it 'should change status from progress to done' do
      subject.status = progress_status
      subject.change_status

      expect(subject.status).to eq(done_status)
    end

    it 'should set status error if current state invalid' do
      subject.status = nil
      subject.change_status

      expect(subject.status).to eq(error_status)
    end
  end

  describe '#set_error_status' do
    it 'should set error status' do
      expect(subject.status).not_to eq(error_status)

      subject.send(:set_error_status)
      expect(subject.status).to eq(error_status)
    end
  end
end
