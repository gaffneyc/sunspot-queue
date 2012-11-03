require "sidekiq/worker"

module Sunspot::Queue::Sidekiq
  class IndexJob
    include ::Sunspot::Queue::Helpers
    include ::Sidekiq::Worker

    sidekiq_options :queue => "sunspot"

    def perform(klass, id)
      without_proxy do
        klass.to_s.constantize.find(id).solr_index
      end
    end
  end
end
