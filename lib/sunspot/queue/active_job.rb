require "sunspot/queue"

module Sunspot::Queue
  module ActiveJob
    require "sunspot/queue/active_job/backend"
    require "sunspot/queue/active_job/index_job"
    require "sunspot/queue/active_job/removal_job"
  end
end
