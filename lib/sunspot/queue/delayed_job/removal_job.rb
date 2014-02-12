require "sunspot/queue/helpers"

module Sunspot::Queue::DelayedJob
  class RemovalJob < Struct.new(:klass, :id)
    include ::Sunspot::Queue::Helpers

    def perform
      Sunspot::Queue::Removal.remove klass, id
    end
  end
end
