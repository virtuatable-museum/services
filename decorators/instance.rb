module Decorators
  class Instance < Draper::Decorator
    delegate_all

    def to_h
      return {
        id: object.id.to_s,
        url: object.url,
        active: object.active,
        running: object.running,
        type: object.type.to_s
      }
    end
  end
end