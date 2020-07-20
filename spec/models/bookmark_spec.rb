# frozen_string_literal: true

RSpec.describe Bookmark do
  subject { build(:post_mark) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(%i[markable_id markable_type]) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:markable) }
  end
end
