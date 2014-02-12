require "sunspot/queue/helpers"

module Sunspot::Queue
  module Removal
    extend ::Sunspot::Queue::Helpers

    def self.remove(klass, id)
      without_proxy do
        ::Sunspot.remove_by_id!(klass, id)
      end
    end
  end
end
