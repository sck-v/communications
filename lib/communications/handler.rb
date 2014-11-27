module Communications
  module Handler

    def process(payload)
      Rails.logger.info(payload)

      payload = JSON.parse(payload).with_indifferent_access

      handle(payload)
    end

    private

    def handle(_)
      raise NotImplementedError
    end
  end
end