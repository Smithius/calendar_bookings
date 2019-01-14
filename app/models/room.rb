class Room < ActiveRecord::Base
  has_many :bookings, dependent: :destroy

  validates_presence_of :number, :name, :size


  def has_conflicting_bookings?(start_date, end_date)
    return bookings.where("(start <= :start_date AND end >= :start_date) "\
                        "OR (start <= :end_date AND end >= :end_date) "\
                        "OR (start > :start_date AND end < :end_date)",
                    {start_date: start_date, end_date: end_date})
         .any?
  end
end
