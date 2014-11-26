module Communications
  module Handler

    def process(payload)
      puts "Payload received: #{payload}"

      payload = JSON.parse(payload).with_indifferent_access

      handle(payload)
    end

    private

    def handle(_)
      raise NotImplementedError
    end
  end
end