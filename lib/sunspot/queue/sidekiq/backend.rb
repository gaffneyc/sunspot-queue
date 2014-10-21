require "sunspot/queue/sidekiq/index_job"
require "sunspot/queue/sidekiq/removal_job"

module Sunspot::Queue::Sidekiq
  class Backend
    attr_reader :configuration

    def initialize(configuration = Sunspot::Queue.configuration)
      @configuration = configuration
    end

    # Job needs to include Sidekiq::Worker
    def enqueue(job, klass, id)
      job.perform_in(@configuration.delay_for, klass.to_s, id)
    end

    def index(klass, id)
      enqueue(index_job, klass, id)
    end

    def remove(klass, id)
      enqueue(removal_job, klass, id)
    end

    private

    def index_job
      configuration.index_job || ::Sunspot::Queue::Sidekiq::IndexJob
    end

    def removal_job
      configuration.removal_job || ::Sunspot::Queue::Sidekiq::RemovalJob
    end
  end
end
