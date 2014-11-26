require 'communications/amqp'

module Communications
  class Publisher

    class << self
      def publish(event, message)
        Communications::Amqp.instance.publish(event, message)
        event
      end
    end
  end
end