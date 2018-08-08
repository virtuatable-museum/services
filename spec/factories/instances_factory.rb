FactoryGirl.define do
  factory :empty_instance, class: Arkaan::Monitoring::Instance do
    factory :instance do
      url 'https://test.service.com/'
      active true
      running true
      type :heroku
    end
  end
end