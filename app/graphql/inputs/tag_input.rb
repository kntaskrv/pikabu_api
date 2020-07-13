# frozen_string_literal: true

module Inputs
  class TagInput < Types::BaseInputObject
    argument :tag, String, required: true
  end
end
