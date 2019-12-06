# frozen_string_literal: true

module Decorators
  # Decorator for a service, transforming it in hash.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Service < Virtuatable::Enhancers::Base
    enhances Arkaan::Monitoring::Service

    def to_h
      {
        path: object.path,
        key: object.key,
        id: object.id.to_s,
        active: object.active,
        routes: routes,
        instances: instances
      }
    end

    private

    def routes
      object.routes.map(&:enhance!).map(&:to_h)
    end

    def instances
      object.instances.map(&:enhance!).map(&:to_h)
    end
  end
end
