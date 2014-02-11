require "sidekiq/worker"
require "sunspot/queue/helpers"

module Sunspot::Queue::Sidekiq
  class IndexJob
    include ::Sunspot::Queue::Helpers
    include ::Sidekiq::Worker

    sidekiq_options :queue => "sunspot"

    def perform(klass, id)
      without_proxy do
        Sunspot.index! [constantize(klass).find(id)]
      end
    end
  end
end
