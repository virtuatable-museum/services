FactoryGirl.define do
  factory :empty_service, class: Arkaan::Monitoring::Service do

    factory :bare_service do
      key 'test_service'
      path '/test'
      diagnostic '/status'
      
      factory :service do
        after :create do |service, evaluator|
          service.routes << build(:route)
          service.instances << build(:instance)
        end
      end
    end
  end
end