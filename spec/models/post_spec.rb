# frozen_string_literal: true

RSpec.describe Post do
  subject { build(:post) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:user) }

    it { is_expected.to have_many(:tags) }
    it { is_expected.to have_many(:images) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:rates) }
    it { is_expected.to have_many(:bookmarks) }
  end
end
