module Decorators
  class Action < Draper::Decorator
    delegate_all

    def to_h
      return {
        type: object.type.to_s,
        username: object.user.username,
        created_at: object.created_at.utc.iso8601
      }
    end
  end
end