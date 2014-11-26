require 'communications/amqp'

require 'amqp'
require 'amqp/utilities/event_loop_helper'

module Communications
  class Receiver

    class << self
      def start!
        AMQP::Utilities::EventLoopHelper.run do
          Communications::Configuration.queues.each do |queue_name, handler_class|
            channel = Communications::Amqp.instance.channel
            channel.prefetch(1)

            channel.queue(Configuration.with_channel_prefix(queue_name), durable: true).subscribe(ack: true) do |metadata, payload|
              handler = handler_class.new

              begin
                result = handler.process(payload)
              rescue
                raise unless process_callback(queue_name, payload, !!result)
              ensure
                metadata.ack
              end
            end
          end
        end
      end

      protected

      def process_callback(queue_name, payload, result)
        return unless Configuration.on_message_callback.respond_to?(:call)

        Configuration.on_message_callback.call(queue_name, payload, result)
      end
    end
  end
end