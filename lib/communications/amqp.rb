require 'singleton'

require 'amqp'
require 'amqp/utilities/event_loop_helper.rb'

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