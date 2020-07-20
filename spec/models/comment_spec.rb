# frozen_string_literal: true

RSpec.describe Comment do
  subject { build(:post_comment) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:commentable) }

    it { is_expected.to have_many(:images) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:rates) }
    it { is_expected.to have_many(:bookmarks) }
  end
end
