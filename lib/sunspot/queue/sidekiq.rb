require "sunspot"
require "sidekiq"

module Sunspot::Queue
  module Sidekiq
    require "sunspot/queue/sidekiq/backend"
    require "sunspot/queue/sidekiq/index_job"
    require "sunspot/queue/sidekiq/removal_job"
  end
end
