require "sunspot/queue/sidekiq/index_job"
require "sunspot/queue/sidekiq/removal_job"

module Sunspot::Queue::Sidekiq
  class Backend
    # Job needs to include Sidekiq::Worker
    def enqueue(job, klass, id)
      job.perform_async(klass, id)
    end

    def index(klass, id)
      ::Sunspot::Queue::Sidekiq::IndexJob.perform_async(klass, id)
    end

    def remove(klass, id)
      ::Sunspot::Queue::Sidekiq::RemovalJob.perform_async(klass, id)
    end
  end
end
