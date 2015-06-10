module Sunspot::Queue
  class Configuration
    attr_accessor :index_job, :removal_job, :force_index_on_failure
  end
end
