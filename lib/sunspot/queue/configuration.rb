module Sunspot::Queue
  class Configuration
    attr_accessor :index_job, :removal_job, :delay_for

    def initialize
      @delay_for = 5.seconds # default `delay_for` is 5 seconds
    end
  end
end
