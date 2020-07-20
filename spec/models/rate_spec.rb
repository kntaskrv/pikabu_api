# frozen_string_literal: true

RSpec.describe Rate do
  subject { build(:post_rate) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(%i[rateable_id rateable_type]).with_message('already has this rate') }
  end

  describe 'association' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:rateable) }
  end
end
