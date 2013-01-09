require "sunspot/queue/sidekiq/index_job"
require "sunspot/queue/sidekiq/removal_job"

module Sunspot::Queue::Sidekiq
  class Backend
    attr_reader :configuration

    def initialize(configuration=Sunspot::Queue.configuration)
      @configuration = configuration
    end

    # Job needs to include Sidekiq::Worker
    def enqueue(job, klass, id)
      job.perform_async(klass, id)
    end

    def index(klass, id)
      configuration.sidekiq_index_job.perform_async(klass, id)
    end

    def remove(klass, id)
      configuration.sidekiq_removal_job.perform_async(klass, id)
    end
  end
end
