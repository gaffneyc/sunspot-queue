require "active_job"
require "sunspot/queue/helpers"

module Sunspot::Queue::ActiveJob
  class IndexJob < ::ActiveJob::Base
    include ::Sunspot::Queue::Helpers

    queue_as :sunspot

    def perform(klass, id)
      without_proxy do
        constantize(klass).find(id).solr_index
      end
    end
  end
end
