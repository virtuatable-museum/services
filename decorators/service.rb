# frozen_string_literal: true

module Decorators
  # Decorator for a service, transforming it in hash.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Service < Draper::Decorator
    delegate_all

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
      decorate_list(:routes, Decorators::Route)
    end

    def instances
      decorate_list(:instances, Decorators::Instance)
    end

    def decorate_list(name, klass)
      object.send(name).map { |route| klass.new(route).to_h }
    end
  end
end
