# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    user
    sequence :title do |n|
      "Title#{n}"
    end
    description { 'Desc' }
    hot { false }
    best { false }
  end
end
