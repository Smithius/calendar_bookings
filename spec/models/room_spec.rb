require 'rails_helper'

RSpec.describe Room, type: :model do
  it {should have_many(:bookings).dependent(:destroy)}

  it {should validate_presence_of(:number)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:size)}
end
