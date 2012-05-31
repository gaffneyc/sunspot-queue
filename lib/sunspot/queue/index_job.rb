require "sunspot/queue/helpers"

module Sunspot::Queue
  class IndexJob
    extend Helpers

    def self.queue
      :sunspot
    end

    def self.perform(klass, id)
      without_proxy do
        record = ::Resque.constantize(klass).find(id)

        Sunspot.index!(record)
      end
    end
  end
end
