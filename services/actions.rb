module Services
  # This service is dedicated to perform actions on instances of service.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Actions
    include Singleton

    # @!attribute [rw] heroku
    #   @return [PlatformAPI::Client] the heroku connection used on this type of instances.
    attr_accessor :heroku

    attr_accessor :logger

    def initialize
      @logger = Logger.new(STDOUT)
      if !ENV['OAUTH_TOKEN'].nil?
        @heroku = PlatformAPI.connect(ENV['OAUTH_TOKEN'])
      end
    end

    def check_instances(instances)
      instances.each do |service_id, instance_ids|
        service = Arkaan::Monitoring::Service.where(_id: service_id).first
        return false if service.nil?
        instance_ids.each do |instance_id|
          return false if service.instances.where(_id: instance_id).first.nil?
        end
      end
      return true
    end

    def check_action(action)
      return respond_to?(action.to_sym)
    end

    def multi(action, instances, session)
      results = []
      instances.each do |service_id, instance_ids|
        tmp_service = Arkaan::Monitoring::Service.where(id: service_id).first
        instance_ids.each do |instance_id|
          instance = tmp_service.instances.where(id: instance_id).first
          created_action = perform_and_save(action, instance, session)
          if created_action != false && created_action.save
            results << Decorators::Action.new(created_action).to_h
          end
        end
      end
      return results
    end

    def perform_and_save(action, managedInstance, session)
      action_done = send(action, managedInstance)
      Arkaan::Monitoring::Action.new(type: action, instance: managedInstance, user: session.account, success: action_done != false)
    end

    # Restarts a given instance depending on its type. For example a heroku instance will be restarted by restarting all dynos.
    # @param managedInstance [Arkaan::Monitoring::Instance] the instance to restart.
    def restart(managedInstance)
      case managedInstance.type
      when :heroku
        begin
          if heroku.nil?
            return false
          end
          if Arkaan::Utils::MicroService.instance.instance.id.to_s == managedInstance.id.to_s
            return false
          end
          heroku.dyno.restart(managedInstance.data[:name], 'web')
        rescue StandardError
          false
        end
      end
    end
  end
end