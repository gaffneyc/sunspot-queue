require "sunspot/queue/helpers"

module Sunspot::Queue
  module Index
    extend ::Sunspot::Queue::Helpers

    def self.index(klass, id)
      without_proxy do
        Sunspot.index! [constantize(klass).find(id)]
      end
    end
  end
end
