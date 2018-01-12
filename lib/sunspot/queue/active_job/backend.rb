require "sunspot/queue/active_job/index_job"
require "sunspot/queue/active_job/removal_job"

module Sunspot::Queue::ActiveJob
  class Backend
    attr_reader :configuration

    def initialize(configuration = Sunspot::Queue.configuration)
      @configuration = configuration
    end

    def index(klass, id)
      index_job.perform_later klass, id
    end

    def remove(klass, id)
      removal_job.perform_later klass, id
    end

    private

    def index_job
      configuration.index_job || ::Sunspot::Queue::ActiveJob::IndexJob
    end

    def removal_job
      configuration.removal_job || ::Sunspot::Queue::ActiveJob::RemovalJob
    end
  end
end
