# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    user
    title { 'Title' }
    description { 'Desc' }
    hot { false }
    best { false }
  end
end
