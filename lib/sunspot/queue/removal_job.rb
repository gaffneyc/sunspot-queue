require "sunspot/queue/helpers"

module Sunspot::Queue
  class RemovalJob
    extend Helpers

    def self.queue
      :solr
    end

    def self.perform(klass, id)
      without_proxy do
        ::Sunspot.remove_by_id(klass, id)
      end
    end
  end
end
