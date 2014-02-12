require "sidekiq/worker"
require "sunspot/queue/helpers"

module Sunspot::Queue::Sidekiq
  class IndexJob
    include ::Sunspot::Queue::Helpers
    include ::Sidekiq::Worker

    sidekiq_options :queue => "sunspot"

    def perform(klass, id)
      Sunspot::Queue::Index.index klass, id
    end
  end
end
