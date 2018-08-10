module Decorators
  class Route < Draper::Decorator
    delegate_all

    def to_h
      return {
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