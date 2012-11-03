require "sunspot/queue/helpers"

module Sunspot::Queue::Resque
  class RemovalJob
    extend ::Sunspot::Queue::Helpers

    def self.queue
      :sunspot
    end

    def self.perform(klass, id)
      without_proxy do
        ::Sunspot.remove_by_id(klass, id)
      end
    end
  end
end
