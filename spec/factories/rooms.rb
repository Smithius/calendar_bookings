FactoryBot.define do
  factory :room do
    number {Faker::Number.number(4)}
    name {Faker::Lorem.word}
    size {Faker::Number.number(4)}
  end
end
