require "sunspot/queue/helpers"

module Sunspot::Queue
  class IndexJob
    extend Helpers

    def self.queue
      :sunspot
    end

    def self.perform(klass, id)
      without_proxy do
        ::Resque.constantize(klass).find(id).solr_index
      end
    end
  end
end
