# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'association' do
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:rates) }
    it { is_expected.to have_many(:bookmarks) }
  end
end
