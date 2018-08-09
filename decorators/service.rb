module Decorators
  class Service < Draper::Decorator
    delegate_all

    def to_h
      return {
        path: object.path,
        key: object.key,
        id: object.id.to_s,
        active: object.active,
        routes: Decorators::Route.decorate_collection(object.routes).map(&:to_h),
        instances: Decorators::Instance.decorate_collection(object.instances).map(&:to_h)
      }
    end

    def to_simple_h
      return {
        path: object.path,
        key: object.key,
        id: object.id.to_s,
        active: object.active,
        routes: object.routes.count,
        instances: object.instances.count
      }
    end
  end
end