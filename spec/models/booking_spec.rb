require 'rails_helper'

RSpec.describe Booking, type: :model do
  it {should belong_to(:room)}

  it {should validate_presence_of(:start)}
  it {should validate_presence_of(:end)}
end