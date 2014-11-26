require 'communications/configuration'
require 'communications/receiver'
require 'communications/publisher'

module Communications
  def self.configure(&block)
    Configuration.build(&block)
  end
end
