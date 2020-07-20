# frozen_string_literal: true

FactoryBot.define do
  factory :post_comment, class: 'Comment' do
    user
    commentable { build(:post) }
    text { 'text' }
  end

  factory :comment_comment, class: 'Comment' do
    user
    commentable { build(:post_comment) }
    text { 'text' }
  end
end
