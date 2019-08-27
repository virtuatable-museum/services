# frozen_string_literal: true

module Decorators
  # Decorator for a route, transforming it in hash.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Route < Draper::Decorator
    delegate_all

    def to_h
      {
        id: object.id.to_s,
        path: object.path,
        verb: object.verb,
        authenticated: object.authenticated,
        premium: object.premium,
        active: object.active
      }
    end
  end
end
