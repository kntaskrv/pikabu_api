# frozen_string_literal: true

FactoryBot.define do
  factory :post_image, class: 'Image' do
    image { 'Image' }
    imageable { build(:post) }
  end

  factory :comment_image, class: 'Image' do
    image { 'Image' }
    imageable { build(:post_comment) }
  end
end
