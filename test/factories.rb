Factory.define :account do |f|
  f.sequence(:name) { |n| "test#{n}"}
  f.password "123456"
  f.password_confirmation { |u| u.password }
  f.sequence(:email) { |n| "test#{n}@test.de"}
  f.email_confirmation { |u| u.email }
end

Factory.define :character do |f|
  f.association :account_id, :factory => :account
  f.name "Mr Labman"
  f.user_id 1144806
  f.api_key "A7416C2DAA5D4283AE4EE7BB8F27BDBC96F3A01B14534656842A9783AC135A8A"
  f.character_id 563818696
  f.corporation_name "J Productions"
  f.corporation_id 603080403
end