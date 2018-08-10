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
            expect(parsed['routes']).to be 1
          end
        end
        describe 'instances' do
          it 'has created the service with an instance' do
            expect(parsed['instances']).to be 1
          end
        end
      end
    end

    it_should_behave_like 'a route', 'get', '/'
  end

  describe 'GET /:id' do
    before do
      get "/#{service.id.to_s}", {app_key: 'test_key', token: 'test_token'}
    end

    describe 'Nominal case' do
      it 'Returns a OK (200)' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          key: 'test_service',
          path: '/test',
          routes: [{
            path: '/route',
            verb: 'post',
            active: true,
            authenticated: false,
            premium: true
          }],
          instances: [{
            url: 'https://test.service.com/',
            active: true,
            running: true,
            type: 'heroku'
          }]
        })
      end
    end

    describe 'Not Found' do
      describe 'Service not found' do
        before do
          get '/unknown', {app_key: 'test_key', token: 'test_token'}
        end

        it 'Returns a Not Found (404)' do
          expect(last_response.status).to be 404
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            status: 404,
            field: 'service_id',
            error: 'unknown'
          })
        end
      end
    end

    it_should_behave_like 'a route', 'get', '/:id'
  end
end