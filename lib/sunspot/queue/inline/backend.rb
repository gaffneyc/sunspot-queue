require "sunspot/queue/inline"
require "sunspot/queue/helpers"

module Sunspot::Queue::Inline
  class Backend
    include ::Sunspot::Queue::Helpers

    def index(klass, id)
      without_proxy do
        constantize(klass).find(id).solr_index
      end
    end

    def remove(klass, id)
      without_proxy do
        ::Sunspot.remove_by_id(klass, id)
      end
    end
  end
end
