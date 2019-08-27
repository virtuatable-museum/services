# frozen_string_literal: true

module Services
  # This service is dedicated to update the elements
  # (services, routes, instances) given to him.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Update
    include Singleton

    # Updates a service with the given parameters.
    # @param service [Arkaan::Monitoring::Service] the service to update.
    # @param parameters [Hash] a hash with the data to update,
    #   accepted keys : 'active', 'premium'
    # @return [Arkaan::Monitoring::Service] the updated service.
    def update_service(service, parameters)
      update_from_params(service, %w[active premium], parameters)
    end

    # Updates an instance with the given parameters.
    # @param instance [Arkaan::Monitoring::Instance] the instance to update.
    # @param parameters [Hash] a hash with the data to update,
    #   accepted keys : 'active'
    # @return [Arkaan::Monitoring::Instance] the updated instance.
    def update_instance(instance, parameters)
      update_from_params(instance, %w[active], parameters)
    end

    # Updates a route with the given parameters.
    # @param route [Arkaan::Monitoring::Route] the route to update.
    # @param parameters [Hash] a hash with the data to update,
    #   accepted keys : 'active', 'authenticated', 'premium'
    # @return [Arkaan::Monitoring::Route] the updated route.
    def update_route(route, parameters)
      update_from_params(route, %w[active authenticated premium], parameters)
    end

    private

    def update_from_params(element, keys, parameters)
      keys.each do |key|
        if parameters.key?(key)
          value = [true, 1, '1', 'true'].include?(parameters[key])
          element.update_attribute(key, value)
        end
      end
      element.reload
      element
    end
  end
end
