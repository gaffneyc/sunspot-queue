require "sunspot/queue/helpers"

module Sunspot::Queue::DelayedJob
  class IndexJob < Struct.new(:klass, :id)
    include ::Sunspot::Queue::Helpers

    def perform
      without_proxy do
        constantize(klass).find(id).solr_index
      end
    end
  end
end
