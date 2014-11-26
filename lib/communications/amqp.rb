require 'singleton'

require 'amqp'
require 'amqp/utilities/event_loop_helper.rb'

module Communications
  class Amqp
    include Singleton

    def publish(route, message)
      AMQP::Utilities::EventLoopHelper.run do
        message = message.to_json if message.respond_to?(:to_json)

        exchange = channel.default_exchange
        exchange.publish(message, routing_key: Configuration.with_channel_prefix(route), content_type: 'application/json')
      end
    end

    def channel
      AMQP::Channel.new(connection)
    end

    private

    def connection
      AMQP.connect
    end
  end
end