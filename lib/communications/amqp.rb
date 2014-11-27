require 'singleton'

module Communications
  class Amqp
    include Singleton

    def channel
      @channel ||= AMQP::Channel.new(connection)
    end

    private

    def connection
      @connection ||= AMQP.connect
    end
  end
end