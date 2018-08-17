module Services
  # This service is dedicated to update the elements (services, routes, instances) given to him.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Update
    include Singleton

    # Updates a service with the given parameters.
    # @param service [Arkaan::Monitoring::Service] the service you want to update.
    # @param parameters [Hash] a hash with the data to update, accepted keys : 'active', 'premium'
    # @return [Arkaan::Monitoring::Service] the updated service for further use.
    def update_service(service, parameters)
      update_from_params(service, ['active','premium'], parameters)
    end

    # Updates an instance with the given parameters.
    # @param instance [Arkaan::Monitoring::Instance] the instance you want to update.
    # @param parameters [Hash] a hash with the data to update, accepted keys : 'active'
    # @return [Arkaan::Monitoring::Instance] the updated instance for further use.
    def update_instance(instance, parameters)
      update_from_params(instance, ['active'], parameters)
    end

    # Updates a route with the given parameters.
    # @param route [Arkaan::Monitoring::Route] the route you want to update.
    # @param parameters [Hash] a hash with the data to update, accepted keys : 'active', 'authenticated', 'premium'
    # @return [Arkaan::Monitoring::Route] the updated route for further use.
    def update_route(route, parameters)
      update_from_params(route, ['active', 'authenticated', 'premium'], parameters)
    end

    private

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