FactoryGirl.define do
  factory :empty_route, class: Arkaan::Monitoring::Route do
    factory :route do
      path '/route'
      verb 'post'
      active true
      premium true
      authenticated false
    end
  end
end