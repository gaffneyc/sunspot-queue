module Sunspot::Queue
  class Configuration
    attr_accessor \
      :resque_index_job, :resque_removal_job,
      :sidekiq_index_job, :sidekiq_removal_job

    def resque_index_job
      @resque_index_job ||= ::Sunspot::Queue::Resque::IndexJob
    end

    def resque_removal_job
      @resque_removal_job ||= ::Sunspot::Queue::Resque::RemovalJob
    end

    def sidekiq_index_job
      @sidekiq_index_job ||= ::Sunspot::Queue::Sidekiq::IndexJob
    end

    def sidekiq_removal_job
      @sidekiq_removal_job ||= ::Sunspot::Queue::Sidekiq::RemovalJob
    end
  end
end