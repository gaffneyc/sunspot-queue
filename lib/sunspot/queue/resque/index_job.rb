require "sunspot/queue/helpers"

module Sunspot::Queue::Resque
  class IndexJob
    extend ::Sunspot::Queue::Helpers

    def self.queue
      :sunspot
    end

    def self.perform(klass, id)
      without_proxy do
        Sunspot.index! [constantize(klass).find(id)]
      end
    end
  end
end
