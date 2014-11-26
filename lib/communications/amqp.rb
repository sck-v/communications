require 'singleton'
require 'bunny'

module Communications
  class Amqp
    include Singleton

    def publish(route, message)
      message = message.to_json if message.respond_to?(:to_json)

      exchange = channel.default_exchange
      exchange.publish(message, routing_key: Configuration.with_channel_prefix(route), content_type: 'application/json')
    end

    def channel
      @channel ||= connection.create_channel
    end

    private

    def connection
      @connection ||= Bunny.new.tap do |c|
        c.start
      end
    end
  end
end