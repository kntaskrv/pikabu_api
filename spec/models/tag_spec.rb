# frozen_string_literal: true

RSpec.describe Tag do
  subject { build(:tag) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:tag) }
  end

  describe 'association' do
    it { is_expected.to have_many(:posts) }
  end
end
