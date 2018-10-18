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

    # Public method used to send an action to the service. It checks that the action exists and performs it.
    # @param action [Symbol] the action to perform on the given instance.
    # @param managedInstance [Arkaan::Monitoring::Instance] the instance on which perform the action.
    # @param session [Arkaan::Authentication::Session] the session of the user performing the action.
    def perform(action, managedInstance, session)
      if respond_to?(action)
        return perform_and_save(action, instance, session)
      else
        return false
      end
    end

    def perform_and_save(action, managedInstance, session)
      action_done = send(action, managedInstance)
      logger.info("action effectuée !!!")
      logger.info("#{action_done} - #{respond_to? action}")
      Arkaan::Monitoring::Action.new(type: action, instance: managedInstance, user: session.account, success: action_done != false)
    end

    # Restarts a given instance depending on its type. For example a heroku instance will be restarted by restarting all dynos.
    # @param managedInstance [Arkaan::Monitoring::Instance] the instance to restart.
    def restart(managedInstance)
      case managedInstance.type
      when :heroku
        if heroku.nil?
          logger.info("Heroku n'a pas été correctement initialisé")
          return false
        end
        if Arkaan::Utils::MicroService.instance.instance.id.to_s == instance.id.to_s
          logger.info("L'instance actuelle est celle qui tente de se redémarrer")
          return false
        end
        logger.info("une toute autre raison !")
        action = heroku.dyno.restart(managedInstance.data[:name], 'web')
        logger.info(action)
        return action
      end
    end
  end
end