# frozen_string_literal: true

module Controllers
  # Controller for the rights, mapped on /rights
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Services < Virtuatable::Controllers::Base
    api_route 'get', '/' do
      raw_services = Arkaan::Monitoring::Service.all
      services = Decorators::Service.decorate_collection(raw_services)
      count = Arkaan::Monitoring::Service.count
      halt 200, { count: count, items: services.map(&:to_h) }.to_json
    end

    api_route 'get', '/:id' do
      halt 200, Decorators::Service.new(service!).to_h.to_json
    end

    api_route 'put', '/:id' do
      ::Services::Update.instance.update_service(service!, params)
      halt 200, { message: 'updated' }.to_json
    end

    api_route 'put', '/:id/instances/:updated_instance' do
      ::Services::Update.instance.update_instance(instance!, params)
      halt 200, { message: 'updated' }.to_json
    end

    api_route 'put', '/:id/routes/:route_id' do
      ::Services::Update.instance.update_route(api_route!, params)
      halt 200, { message: 'updated' }.to_json
    end

    api_route 'delete', '/:id/instances/:updated_instance' do
      instance!.delete
      halt 200, { message: 'deleted' }.to_json
    end

    api_route 'delete', '/:id/routes/:route_id' do
      api_route!.delete
      halt 200, { message: 'deleted' }.to_json
    end

    def service!
      service = Arkaan::Monitoring::Service.where(id: params['id']).first
      api_not_found 'service_id.unknown' if service.nil?
      service
    end

    def api_route!
      api_route = service!.routes.where(id: params['route_id']).first
      api_not_found 'route_id.unknown' if api_route.nil?
      api_route
    end

    def instance!
      instance = service!.instances.where(id: params['updated_instance']).first
      api_not_found 'instance_id.unknown' if instance.nil?
      instance
    end
  end
end
