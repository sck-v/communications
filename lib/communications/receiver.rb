require 'communications/amqp'

module Communications
  class Receiver

    class << self
      def start!
        channel = Communications::Amqp.instance.channel
        exchange = channel.direct('excursiopedia', durable: true)
        queue = channel.queue('')

        Communications::Configuration.queues.each do |queue_name, handler_class|
          queue.bind(exchange, routing_key: Configuration.with_channel_prefix(queue_name))
        end

        queue.subscribe(manual_ack: true) do |delivery_info, _, payload|
          Rails.logger.info delivery_info.routing_key
          Rails.logger.info payload
          # handler = handler_class.new

          # begin
          #   result = handler.process(payload)
          # rescue
          #   raise unless process_callback(queue_name, payload, !!result)
          # ensure
          channel.ack(delivery_info.delivery_tag, false)
          # end
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