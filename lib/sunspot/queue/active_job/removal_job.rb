require "active_job"
require "sunspot/queue/helpers"

module Sunspot::Queue::ActiveJob
  class RemovalJob < ::ActiveJob::Base
    include ::Sunspot::Queue::Helpers

    queue_as :sunspot

    def perform(klass, id)
      without_proxy do
        ::Sunspot.remove_by_id(klass, id)
      end
    end
  end
end
