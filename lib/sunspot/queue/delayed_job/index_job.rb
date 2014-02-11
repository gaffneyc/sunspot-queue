require "sunspot/queue/helpers"

module Sunspot::Queue::DelayedJob
  class IndexJob < Struct.new(:klass, :id)
    include ::Sunspot::Queue::Helpers

    def perform
      without_proxy do
        Sunspot.index! [constantize(klass).find(id)]
      end
    end
  end
end
