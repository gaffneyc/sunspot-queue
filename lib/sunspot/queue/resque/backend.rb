require "resque"
require "sunspot/queue/resque/index_job"
require "sunspot/queue/resque/removal_job"

module Sunspot::Queue::Resque
  class Backend
    attr_reader :configuration

    def initialize(configuration=Sunspot::Queue.configuration)
      @configuration = configuration
    end

    def enqueue(job, klass, id)
      ::Resque.enqueue(job, klass, id)
    end

    def index(klass, id)
      enqueue(configuration.resque_index_job, klass, id)
    end

    def remove(klass, id)
      enqueue(configuration.resque_removal_job, klass, id)
    end
  end
end
