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
    describe 'bad request errors' do
      describe 'no token error' do
        before do
          get '/', {app_key: 'test_key'}
        end
        it 'Raises a bad request (400) error when the parameters don\'t contain the token of the gateway' do
          expect(last_response.status).to be 400
        end
        it 'returns the correct response if the parameters do not contain a gateway token' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'bad_request'})
        end
      end
      describe 'no application key error' do
        before do
          get '/', {token: 'test_token'}
        end
        it 'Raises a bad request (400) error when the parameters don\'t contain the application key' do
          expect(last_response.status).to be 400
        end
        it 'returns the correct response if the parameters do not contain a application key' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'bad_request'})
        end
      end
    end
    describe 'not_found errors' do
      describe 'application not found' do
        before do
          get '/', {token: 'test_token', app_key: 'another_key'}
        end
        it 'Raises a not found (404) error when the key doesn\'t belong to any application' do
          expect(last_response.status).to be 404
        end
        it 'returns the correct body when the gateway doesn\'t exist' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'application_not_found'})
        end
      end
      describe 'gateway not found' do
        before do
          get '/', {token: 'other_token', app_key: 'test_key'}
        end
        it 'Raises a not found (404) error when the gateway does\'nt exist' do
          expect(last_response.status).to be 404
        end
        it 'returns the correct body when the gateway doesn\'t exist' do
          expect(JSON.parse(last_response.body)).to eq({'message' => 'gateway_not_found'})
        end
      end
    end
  end
end