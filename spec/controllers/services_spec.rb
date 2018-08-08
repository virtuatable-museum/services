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
        expect(last_response.body).to include_json({
          'count' => 1,
          'items' => [
            {'key' => 'test_service', 'path' => '/test'}
          ]
        })
      end
      describe 'associations' do
        let!(:parsed) { JSON.parse(last_response.body)['items'].first }

        describe 'routes' do
          it 'has created the service with a route' do
            expect(parsed['routes'].count).to be 1
          end
          it 'has created the route correctly' do
            expect(parsed['routes'].first).to include_json({'verb' => 'post', 'path' => '/route'})
          end
        end
        describe 'instances' do
          it 'has created the service with an instance' do
            expect(parsed['instances'].count).to be 1
          end
          it 'has created the instance correctly' do
            expect(parsed['instances'].first).to include_json({
              'url' => 'https://test.service.com/',
              'type' => 'heroku',
              'running' => true,
              'active' => true
            })
          end
        end
      end
    end

    it_should_behave_like 'a route', 'get', '/'
  end
end