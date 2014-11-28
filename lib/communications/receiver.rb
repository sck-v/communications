require 'communications/amqp'

module Communications
  class Receiver

    class << self
      def start!
        Communications::Configuration.queues.each do |queue_name, handler_class|
          puts "[Communications] Handling messages from #{queue_name} with #{handler_class}"

          channel = Communications::Amqp.instance.channel
          channel.prefetch(1)

          queue = channel.queue(Configuration.with_channel_prefix(queue_name), durable: true)
          handler = handler_class.new

          queue.subscribe(manual_ack: true) do |delivery_info, _, payload|
            Communications.logger.info("[Communications][Incoming] #{payload}")
            begin
              result = handler.process(payload)
            rescue => e
              Communications.logger.info("[Communications][Failure] #{payload}. Message: #{e.message}")
              raise unless process_failure(queue_name, payload, !!result)
            ensure
              channel.ack(delivery_info.delivery_tag, false)
            end
          end
        end
      end

      protected

      def process_failure(queue_name, payload, result)
        return unless Configuration.on_message_failure_callback.respond_to?(:call)

        Configuration.on_message_failure_callback.call(queue_name, payload, result)
      end
    end
  end
end