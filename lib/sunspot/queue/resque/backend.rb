require "resque"
require "sunspot/queue/resque/index_job"
require "sunspot/queue/resque/removal_job"

module Sunspot::Queue::Resque
  class Backend
    attr_reader :configuration

    def initialize(configuration = Sunspot::Queue.configuration)
      @configuration = configuration
    end

    def enqueue(job, klass, id)
      ::Resque.enqueue(job, klass, id)
    end

    def index(klass, id)
      enqueue(index_job, klass, id)
    end

    def remove(klass, id)
      enqueue(removal_job, klass, id)
    end

    private

    def index_job
      configuration.index_job || ::Sunspot::Queue::Resque::IndexJob
    end

    def removal_job
      configuration.removal_job || ::Sunspot::Queue::Resque::RemovalJob
    end
  end
end
