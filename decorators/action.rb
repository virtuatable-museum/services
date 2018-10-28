module Decorators
  class Action < Draper::Decorator
    delegate_all

    def to_h
      return {
        type: object.type.to_s,
        username: object.user.username,
        instance_id: object.instance.id.to_s,
        service_id: object.instance.service.id.to_s,
        created_at: object.created_at.utc.iso8601
      }
    end
  end
end