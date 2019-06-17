module Controllers
  # Controller for the rights, mapped on /rights
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Services < Arkaan::Utils::Controller

    load_errors_from __FILE__

    before do
      @session = check_session('service')
    end

    before '/services/:id/?*' do
      @service = check_service if params['id'] != 'actions'
    end

    before '/services/:id/instances/:updated_instance/?*' do
      @instance = check_instance
    end

    before '/services/:id/routes/:route_id/?*' do
      @route = check_route
    end
    
    declare_route 'get', '/' do
      services = Decorators::Service.decorate_collection(Arkaan::Monitoring::Service.all)
      halt 200, {count: Arkaan::Monitoring::Service.count, items: services.map(&:to_h)}.to_json
    end

    declare_route 'get', '/:id' do
      halt 200, Decorators::Service.new(@service).to_h.to_json
    end

    declare_route 'put', '/:id' do
      ::Services::Update.instance.update_service(@service, params)
      halt 200, {message: 'updated'}.to_json
    end

    declare_route 'put', '/:id/instances/:updated_instance' do
      ::Services::Update.instance.update_instance(@instance, params)
      halt 200, {message: 'updated'}.to_json
    end

    declare_route 'put', '/:id/routes/:route_id' do
      ::Services::Update.instance.update_route(@route, params)
      halt 200, {message: 'updated'}.to_json
    end

    declare_route 'delete', '/:id/instances/:updated_instance' do
      @instance.delete
      halt 200, {message: 'deleted'}.to_json
    end

    declare_route 'delete', '/:id/routes/:route_id' do
      @route.delete
      halt 200, {message: 'deleted'}.to_json
    end

    def check_service
      service = Arkaan::Monitoring::Service.where(id: params['id']).first
      custom_error(404, "service.service_id.unknown") if service.nil?
      service
    end

    def check_route
      route = @service.routes.where(id: params['route_id']).first
      custom_error(404, "route.route_id.unknown") if route.nil?
      route
    end

    def check_instance
      instance = @service.instances.where(id: params['updated_instance']).first
      custom_error(404, "instance.instance_id.unknown") if instance.nil?
      instance
    end
  end
end