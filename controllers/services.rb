module Controllers
  # Controller for the rights, mapped on /rights
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Services < Arkaan::Utils::Controller

    load_errors_from __FILE__

    before '/:id' do
      @service = check_service
    end

    before '/:id/instances/:instance_id' do
      @service = check_service
      @instance = check_instance
    end
    
    declare_route 'get', '/' do
      services = Decorators::Service.decorate_collection(Arkaan::Monitoring::Service.all)
      halt 200, {count: Arkaan::Monitoring::Service.count, items: services.map(&:to_simple_h)}.to_json
    end

    declare_route 'get', '/:id' do
      halt 200, Decorators::Service.new(@service).to_h.to_json
    end

    declare_route 'put', '/:id' do
      service = ::Services::Update.instance.update_service(@service, params)
      halt 200, {message: 'updated'}.to_json
    end

    declare_route 'put', '/:id/instances/:instance_id' do

    end

    def check_service
      service = Arkaan::Monitoring::Service.where(id: params['id']).first
      custom_error(404, "service.service_id.unknown") if service.nil?
      return service
    end

    def check_instance
      instance = @service.instances.where(id: params['instance_id']).first
      custom_error(404, "instance.instance_id.unknown") if instance.nil?
      return @instance
    end
  end
end