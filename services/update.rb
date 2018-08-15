module Services
  # This service is dedicated to update the elements (services, routes, instances) given to him.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Update
    include Singleton

    def update_service(service, parameters)
      update_from_params(service, ['active','premium'], parameters)
    end

    def update_instance(instance, parameters)
      update_from_params(instance, ['active'], parameters)
    end

    def update_route(route, parameters)
      update_from_params(route, ['active', 'authenticated', 'premium'], parameters)
    end

    def update_from_params(element, keys, parameters)
      keys.each do |key|
        if parameters.key?(key)
          element.update_attribute(key, [true, 1, '1', 'true'].include?(parameters[key]))
        end
      end
      element.reload
      element
    end
  end
end