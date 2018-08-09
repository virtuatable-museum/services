module Controllers
  # Controller for the rights, mapped on /rights
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Services < Arkaan::Utils::Controller

    load_errors_from __FILE__
    
    declare_route 'get', '/' do
      services = Decorators::Service.decorate_collection(Arkaan::Monitoring::Service.all)
      halt 200, {count: Arkaan::Monitoring::Service.count, items: services.map(&:to_simple_h)}.to_json
    end

    declare_route 'get', '/:id' do
      service = Arkaan::Monitoring::Service.where(id: params['id']).first
      custom_error(404, "service.service_id.unknown") if service.nil?
      halt 200, Decorators::Service.new(service).to_h.to_json
    end
  end
end