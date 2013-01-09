module Sunspot
  module Queue
    class Error < StandardError; end
    class NotPersistedError < Error; end

    def self.configure(&blk)
      yield configuration
    end

    def self.configuration
      @configuration ||= Sunspot::Queue::Configuration.new
    end
  end
end

require "sunspot/queue/version"
require "sunspot/queue/configuration"
require "sunspot/queue/session_proxy"
