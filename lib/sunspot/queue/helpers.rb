require "sunspot/queue/session_proxy"

module Sunspot::Queue
  module Helpers
    def without_proxy
      # Pop off the queueing proxy for the block if it's in place so we don't
      # requeue the same job multiple times.
      if Sunspot.session.instance_of?(SessionProxy)
        proxy = Sunspot.session
        Sunspot.session = proxy.session

        begin
          yield
        ensure
          Sunspot.commit rescue nil
          Sunspot.session = proxy
        end
      else
        yield
      end
    end
  end
end
