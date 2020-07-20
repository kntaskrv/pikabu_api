# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'User' }
    admin { false }
    rate { rand(100) }
  end
end
