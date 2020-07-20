# frozen_string_literal: true

FactoryBot.define do
  factory :post_rate, class: 'Rate' do
    user
    rateable { build(:post) }
    status { 'like' }
  end

  factory :comment_rate, class: 'Rate' do
    user
    rateable { build(:post_comment) }
    status { 'like' }
  end
end
