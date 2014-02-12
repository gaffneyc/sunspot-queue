require "sunspot/queue/helpers"

module Sunspot::Queue::Resque
  class RemovalJob
    extend ::Sunspot::Queue::Helpers

    def self.queue
      :sunspot
    end

    def self.perform(klass, id)
      Sunspot::Queue::Removal.remove klass, id
    end
  end
end
