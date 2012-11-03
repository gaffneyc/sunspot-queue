require "resque"
require "sunspot/queue/resque/index_job"
require "sunspot/queue/resque/removal_job"

module Sunspot::Queue::Resque
  class Backend
    def enqueue(job, klass, id)
      ::Resque.enqueue(job, klass, id)
    end

    def index(klass, id)
      enqueue(::Sunspot::Queue::Resque::IndexJob, klass, id)
    end

    def remove(klass, id)
      enqueue(::Sunspot::Queue::Resque::RemovalJob , klass, id)
    end
  end
end
