FactoryBot.define do
  factory :booking do
    start {Faker::Date.backward(30)}
    add_attribute(:end) {Faker::Date.forward(30)}
    room_id { nil }
  end
end
