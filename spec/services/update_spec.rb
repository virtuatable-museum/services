RSpec.describe Services::Update do
  before :each do
    DatabaseCleaner.clean
  end

  describe :update_service do
    describe 'update of the active flag' do
      let!(:non_active) { create(:service, key: 'nonactive', active: false) }
      let!(:active) { create(:service, key: 'active', active: true) }

      it 'updates to true if given in parameters as a boolean' do
        updated = Services::Update.instance.update_service(non_active, {'active' => true})
        expect(updated.active).to be true
      end
      it 'updates to true if given in parameters as an integer' do
        updated = Services::Update.instance.update_service(non_active, {'active' => 1})
        expect(updated.active).to be true
      end
      it 'updates to true if given in parameters as a string' do
        updated = Services::Update.instance.update_service(non_active, {'active' => 'true'})
        expect(updated.active).to be true
      end
      it 'updates to false' do
        updated = Services::Update.instance.update_service(active, {'active' => false})
        expect(updated.active).to be false
      end
    end
    describe 'update of the premium flag' do
      let!(:non_premium) { create(:service, key: 'nonpremium', premium: false) }
      let!(:premium) { create(:service, key: 'premium', premium: true) }

      it 'updates to true if given in parameters as a boolean' do
        updated = Services::Update.instance.update_service(non_premium, {'premium' => true})
        expect(updated.premium).to be true
      end
      it 'updates to true if given in parameters as an integer' do
        updated = Services::Update.instance.update_service(non_premium, {'premium' => 1})
        expect(updated.premium).to be true
      end
      it 'updates to true if given in parameters as a string' do
        updated = Services::Update.instance.update_service(non_premium, {'premium' => 'true'})
        expect(updated.premium).to be true
      end
      it 'updates to false' do
        updated = Services::Update.instance.update_service(premium, {'premium' => false})
        expect(updated.premium).to be false
      end
    end
  end

  describe :update_route do
    describe 'update of the active flag' do
      let!(:service) { create(:service) }
      let!(:non_active) { create(:route, active: false, service: service) }
      let!(:active) { create(:route, active: true, service: service) }

      it 'updates to true if given in parameters as a boolean' do
        updated = Services::Update.instance.update_route(non_active, {'active' => true})
        expect(updated.active).to be true
      end
      it 'updates to true if given in parameters as an integer' do
        updated = Services::Update.instance.update_route(non_active, {'active' => 1})
        expect(updated.active).to be true
      end
      it 'updates to true if given in parameters as a string' do
        updated = Services::Update.instance.update_route(non_active, {'active' => 'true'})
        expect(updated.active).to be true
      end
      it 'updates to false' do
        updated = Services::Update.instance.update_route(active, {'active' => false})
        expect(updated.active).to be false
      end
    end
    describe 'update of the premium flag' do
      let!(:service) { create(:service) }
      let!(:non_premium) { create(:route, premium: false, service: service) }
      let!(:premium) { create(:route, premium: true, service: service) }

      it 'updates to true if given in parameters as a boolean' do
        updated = Services::Update.instance.update_route(non_premium, {'premium' => true})
        expect(updated.premium).to be true
      end
      it 'updates to true if given in parameters as an integer' do
        updated = Services::Update.instance.update_route(non_premium, {'premium' => 1})
        expect(updated.premium).to be true
      end
      it 'updates to true if given in parameters as a string' do
        updated = Services::Update.instance.update_route(non_premium, {'premium' => 'true'})
        expect(updated.premium).to be true
      end
      it 'updates to false' do
        updated = Services::Update.instance.update_route(premium, {'premium' => false})
        expect(updated.premium).to be false
      end
    end
    describe 'update of the authenticated flag' do
      let!(:service) { create(:service) }
      let!(:non_authenticated) { create(:route, authenticated: false, service: service) }
      let!(:authenticated) { create(:route, authenticated: true, service: service) }

      it 'updates to true if given in parameters as a boolean' do
        updated = Services::Update.instance.update_route(non_authenticated, {'authenticated' => true})
        expect(updated.authenticated).to be true
      end
      it 'updates to true if given in parameters as an integer' do
        updated = Services::Update.instance.update_route(non_authenticated, {'authenticated' => 1})
        expect(updated.authenticated).to be true
      end
      it 'updates to true if given in parameters as a string' do
        updated = Services::Update.instance.update_route(non_authenticated, {'authenticated' => 'true'})
        expect(updated.authenticated).to be true
      end
      it 'updates to false' do
        updated = Services::Update.instance.update_route(authenticated, {'authenticated' => false})
        expect(updated.authenticated).to be false
      end
    end
  end

  describe :update_instance do
    describe 'update of the active flag' do
      let!(:service) { create(:service) }
      let!(:non_active) { create(:instance, active: false, service: service) }
      let!(:active) { create(:instance, active: true, service: service) }

      it 'updates to true if given in parameters as a boolean' do
        updated = Services::Update.instance.update_instance(non_active, {'active' => true})
        expect(updated.active).to be true
      end
      it 'updates to true if given in parameters as an integer' do
        updated = Services::Update.instance.update_instance(non_active, {'active' => 1})
        expect(updated.active).to be true
      end
      it 'updates to true if given in parameters as a string' do
        updated = Services::Update.instance.update_instance(non_active, {'active' => 'true'})
        expect(updated.active).to be true
      end
      it 'updates to false' do
        updated = Services::Update.instance.update_instance(active, {'active' => false})
        expect(updated.active).to be false
      end
    end
  end
end