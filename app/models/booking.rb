class Booking < ActiveRecord::Base
  belongs_to :room

  validates_presence_of :start, :end
end
