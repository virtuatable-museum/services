FactoryGirl.define do
  factory :empty_service, class: Arkaan::Monitoring::Service do
    factory :service do
      key 'test_service'
      path '/test'
      diagnostic '/status'

      after :create do |service, evaluator|
        service.routes << build(:route)
      end
    end
  end
end