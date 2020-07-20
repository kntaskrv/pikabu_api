# frozen_string_literal: true

FactoryBot.define do
  factory :post_mark, class: 'Bookmark' do
    user
    markable { build(:post) }
  end

  factory :comment_mark, class: 'Bookmark' do
    user
    markable { build(:post_comment) }
  end
end
