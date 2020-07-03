class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.now
    Time.zone.now
  end
end
