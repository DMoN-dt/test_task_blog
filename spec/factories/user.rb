FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@some-domain.local"
  end
end

FactoryGirl.define do
  factory :user, :class => 'User' do
    email
    password 'z123456x'
    password_confirmation 'z123456x'
  end
end