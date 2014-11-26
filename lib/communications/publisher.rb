require 'communications/amqp'

module Communications
  class Publisher

    class << self
      def publish(event, message)
        AMQP::Utilities::EventLoopHelper.run do
          EM.next_tick do
            message = message.to_json if message.respond_to?(:to_json)

            channel = Communications::Amqp.instance.channel
            exchange = channel.default_exchange
            exchange.publish(message, routing_key: Configuration.with_channel_prefix(event), content_type: 'application/json')
          end
        end
      end
    end
  end
end