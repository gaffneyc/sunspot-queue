require "sunspot/queue/helpers"

module Sunspot::Queue::DelayedJob
  class IndexJob < Struct.new(:klass, :id)
    include ::Sunspot::Queue::Helpers

    def perform
      Sunspot::Queue::Index.index klass, id
    end
  end
end
