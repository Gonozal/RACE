# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    name {Factory.next(:name)}
    password 'Test123'
    password_confirmation {|u| u.password}
    email {Factory.next(:email)}
    email_confirmation {|u| u.email}
  end

  sequence :name do |n|
    "TestAcc#{n}"
  end
  
  sequence :email do |n|
    "TestAcc#{n}@test.com"
  end
end
