FactoryBot.define do
  factory :product do
    name { "Produto #{SecureRandom.hex(3)}" }
    price { 9.99 }
  end
end