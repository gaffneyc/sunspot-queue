require "sidekiq/worker"
require "sunspot/queue/helpers"

module Sunspot::Queue::Sidekiq
  class RemovalJob
    include ::Sunspot::Queue::Helpers
    include ::Sidekiq::Worker

    sidekiq_options :queue => "sunspot"

    def perform(klass, id)
      Sunspot::Queue::Removal.remove klass, id
    end
  end
end
