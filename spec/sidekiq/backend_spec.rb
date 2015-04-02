require "spec_helper"

describe Sunspot::Queue::Sidekiq::Backend do

  # Mock SidekiqJob
  class CustomSidekiqJob
    include ::Sidekiq::Worker

    def perform(klass, id)
    end
  end

  subject(:backend) { described_class.new(configuration) }

  let(:configuration) { ::Sunspot::Queue::Configuration.new }

  describe "#index" do
    it "uses the index job set in the global configuration" do
      configuration.index_job = CustomSidekiqJob

      expect do
        backend.index(Person, 9)
      end.to change { CustomSidekiqJob.jobs.size }.by(1)
    end

    it "uses the default index job if one is not configured" do
      expect do
        backend.index(Person, 11)
      end.to change { ::Sunspot::Queue::Sidekiq::IndexJob.jobs.size }.by(1)
    end

    it "performs the job in real time in case of failure queueing the job" do
      configuration.force_index_on_failure = true
      Sunspot::Queue::Sidekiq::IndexJob.should_receive(:perform_async) { raise 'some error' }
      Sunspot::Queue::Sidekiq::IndexJob.should_receive(:perform).with('Person', 12)

      backend.index(Person, 12)
    end

    it "raises the error witout performing the job in real time in case of failure queueing the job" do
      configuration.force_index_on_failure = false
      Sunspot::Queue::Sidekiq::IndexJob.should_receive(:perform_async) { raise 'some error' }
      Sunspot::Queue::Sidekiq::IndexJob.should_not_receive(:perform)

      expect { backend.index(Person, 12) }.to raise_error('some error')
    end
  end

  describe "#remove" do
    it "uses the removal job set in the global configuration" do
      configuration.removal_job = CustomSidekiqJob

      expect do
        backend.remove(Person, 11)
      end.to change { CustomSidekiqJob.jobs.size }.by(1)
    end

    it "uses the default removal job if one is not configured" do
      expect do
        backend.remove(Person, 11)
      end.to change { ::Sunspot::Queue::Sidekiq::RemovalJob.jobs.size }.by(1)
    end
  end
end
