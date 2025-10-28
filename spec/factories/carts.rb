FactoryBot.define do
  factory :cart do
    total_price     { 0 }
    status          { :active }
    last_activity_at { Time.current }
  end
end