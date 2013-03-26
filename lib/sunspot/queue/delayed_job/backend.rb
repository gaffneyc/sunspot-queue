require "delayed_job"
require "sunspot/queue/delayed_job/index_job"
require "sunspot/queue/delayed_job/removal_job"

module Sunspot::Queue::DelayedJob
  class Backend
    attr_reader :configuration

    def initialize(configuration = Sunspot::Queue.configuration)
      @configuration = configuration
    end

    def enqueue(job)
      Delayed::Job.enqueue(job)
    end

    def index(klass, id)
      enqueue(index_job.new(klass, id))
    end

    def remove(klass, id)
      enqueue(removal_job.new(klass, id))
    end

    private

    def index_job
      configuration.index_job || ::Sunspot::Queue::DelayedJob::IndexJob
    end

    def removal_job
      configuration.removal_job || ::Sunspot::Queue::DelayedJob::RemovalJob
    end
  end
end
