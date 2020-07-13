# frozen_string_literal: true

module Inputs
  class ImageInput < Types::BaseInputObject
    argument :remote_image_url, String, required: true
  end
end
