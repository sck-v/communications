require 'delegate'

module Communications
  class Configuration
    class Delegator < SimpleDelegator
      def handle(event, options)
        handler = options.delete(:with)
        raise ArgumentError if handler.blank?

        __getobj__.class.queues.merge!(event => handler)
      end

      def on_message(&block)
        __getobj__.class.on_message_callback = block
      end
    end

    cattr_accessor :queues
    @@queues = {}

    cattr_accessor :on_message_callback
    @@on_message_callback = nil

    cattr_accessor :channel_prefix
    @@channel_prefix = 'exc_partners'

    class << self
      def build(&block)
        new.tap do |c|
          c.build(&block)
        end
      end

      def with_channel_prefix(route)
        "#{channel_prefix}.#{route}"
      end
    end

    def build(&block)
      configuration = Delegator.new(self)
      configuration.instance_eval(&block)
      self
    end
  end
end