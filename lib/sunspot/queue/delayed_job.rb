require "sunspot/queue"

module Sunspot::Queue
  module DelayedJob
    require "sunspot/queue/delayed_job/backend"
    require "sunspot/queue/delayed_job/index_job"
    require "sunspot/queue/delayed_job/removal_job"
  end
end
