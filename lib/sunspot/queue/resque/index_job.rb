require "sunspot/queue/helpers"

module Sunspot::Queue::Resque
  class IndexJob
    extend ::Sunspot::Queue::Helpers

    def self.queue
      :sunspot
    end

    def self.perform(klass, id)
      Sunspot::Queue::Index.index klass, id
    end
  end
end
