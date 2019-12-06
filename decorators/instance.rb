# frozen_string_literal: true

module Decorators
  # Decorator for an instance, transforming it in hash.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Instance < Virtuatable::Enhancers::Base
    enhances Arkaan::Monitoring::Instance

    def to_h
      {
        id: object.id.to_s,
        url: object.url,
        active: object.active,
        running: object.running,
        type: object.type.to_s
      }
    end
  end
end
