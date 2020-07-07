class ApplicationRecord < ActiveRecord::Base
  include PgSearch::Model
  self.abstract_class = true

  def self.now
    Time.zone.now
  end
end
