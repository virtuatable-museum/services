RSpec.describe Controllers::Services do

  before do
    DatabaseCleaner.clean
  end

  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }
  let!(:gateway) { create(:gateway) }
  let!(:service) { create(:service) }

  def app
    Controllers::Services.new
  end

  describe 'GET /' do
    describe 'nominal case' do
      before do
        get '/', {app_key: 'test_key', token: 'test_token'}
      end
      it 'Returns a OK (200) status code when querying for the list of services' do
        expect(last_response.status).to be 200
      end
      it 'returns the correct body for the list of services' do
        expect(JSON.parse(last_response.body)).to eq({
          'count' => 1,
          'items' => [
            {
              'id' => service.id.to_s,
              'key' => 'test_service',
              'path' => '/test',
              'routes' => [
                {
                  'id' => service.routes.first.id.to_s,
                  'verb' => 'post',
                  'path' => '/route'
                }
              ]
            }
          ]
        })
      end
    end

    it_should_behave_like 'a route', 'get', '/'
  end
end