# frozen_string_literal: true

RSpec.describe Image do
  subject { build(:post_image) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:image) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:imageable) }
  end
end
