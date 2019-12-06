# frozen_string_literal: true

module Controllers
  # Controller for the rights, mapped on /rights
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Services < Virtuatable::Controllers::Base
    api_route 'get', '/' do
      api_list all_services.map(&:enhance!)
    end

    api_route 'get', '/:id' do
      api_item service!.enhance!
    end

    api_route 'put', '/:id' do
      ::Services::Update.instance.update_service(service!, params)
      api_ok 'updated'
    end

    api_route 'put', '/:id/instances/:updated_instance' do
      ::Services::Update.instance.update_instance(instance!, params)
      api_ok 'updated'
    end

    api_route 'put', '/:id/routes/:route_id' do
      ::Services::Update.instance.update_route(api_route!, params)
      api_ok 'updated'
    end

    api_route 'delete', '/:id/instances/:updated_instance' do
      instance!.delete
      api_ok 'deleted'
    end

    api_route 'delete', '/:id/routes/:route_id' do
      api_route!.delete
      api_ok 'deleted'
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

    def all_services
      Arkaan::Monitoring::Service.all
    end
  end
end
