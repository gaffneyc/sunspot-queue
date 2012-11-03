require "sunspot/queue"

module Sunspot::Queue
  module Resque
    require "sunspot/queue/resque/backend"
    require "sunspot/queue/resque/index_job"
    require "sunspot/queue/resque/removal_job"
  end
end

# Backwards compatability with 0.9.x. Will be removed by 1.0 / 0.11.
::Sunspot::Queue::IndexJob   = ::Sunspot::Queue::Resque::IndexJob
::Sunspot::Queue::RemovalJob = ::Sunspot::Queue::Resque::RemovalJob
