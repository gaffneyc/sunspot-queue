module Sunspot
  module Queue
    class Error < StandardError; end
    class NotPersistedError < Error; end

    VERSION = "0.9.0"
  end
end

require "sunspot/queue/session_proxy"
require "sunspot/queue/index_job"
require "sunspot/queue/removal_job"
