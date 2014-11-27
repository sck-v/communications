require 'singleton'
require 'bunny'

module Communications
  class Amqp
    include Singleton

    def channel
      @channel ||= connection.create_channel
    end

    private

    def connection
      @connection ||= Bunny.new.tap do |connection|
        connection.start
      end
    end
  end
end